#!/usr/bin/env python3
"""
Daily Database Backup Script — 7-day rotating weekly backup
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Creates folders:
  DB-Back-01-260311  (Monday)
  DB-Back-02-260312  (Tuesday)
  DB-Back-03-260313  (Wednesday)
  DB-Back-04-260314  (Thursday)
  DB-Back-05-260315  (Friday)
  DB-Back-06-260316  (Saturday)
  DB-Back-07-260317  (Sunday)

Each week, the same day's folder is replaced (overwritten).
Keeps structure (DDL) + data (INSERT statements).

Usage:
  python3 daily_backup.py              # Run backup now
  python3 daily_backup.py --dry-run    # Preview without writing
"""

import os
import sys
import shutil
import logging
from datetime import datetime, date
from decimal import Decimal

# ─── Config ───
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
BACKUP_ROOT = SCRIPT_DIR  # x90-bakDB/

# Add FastAPI project to path for database imports
FASTAPI_DIR = os.path.join(os.path.dirname(BACKUP_ROOT), 'x02-backEnd', 'x0201-fastAPI')
sys.path.insert(0, FASTAPI_DIR)

# ─── Logging ───
LOG_FILE = os.path.join(BACKUP_ROOT, 'backup.log')
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s',
    handlers=[
        logging.FileHandler(LOG_FILE),
        logging.StreamHandler(),
    ]
)
log = logging.getLogger('db-backup')


def sql_val(v):
    """Convert a Python value to SQL literal."""
    if v is None:
        return 'NULL'
    if isinstance(v, bool):
        return '1' if v else '0'
    if isinstance(v, (int, float, Decimal)):
        return str(v)
    if isinstance(v, (datetime, date)):
        return f"'{v}'"
    if isinstance(v, bytes):
        return f"X'{v.hex()}'"
    s = str(v).replace("'", "''")
    return f"'{s}'"


def run_backup(dry_run=False):
    from sqlalchemy import inspect, text
    from database import engine

    now = datetime.now()
    day_of_week = now.isoweekday()  # 1=Monday, 7=Sunday
    date_str = now.strftime('%y%m%d')
    folder_name = f'DB-Back-{day_of_week:02d}-{date_str}'
    backup_dir = os.path.join(BACKUP_ROOT, folder_name)

    log.info(f'═══ Daily Backup Start ═══')
    log.info(f'Day: {day_of_week} ({now.strftime("%A")})')
    log.info(f'Folder: {folder_name}')

    if dry_run:
        log.info('[DRY RUN] Would create backup — no files written')
        return

    # Remove old backup for this day-of-week (if exists from last week)
    for existing in os.listdir(BACKUP_ROOT):
        if existing.startswith(f'DB-Back-{day_of_week:02d}-') and existing != folder_name:
            old_path = os.path.join(BACKUP_ROOT, existing)
            if os.path.isdir(old_path):
                log.info(f'Removing old backup: {existing}')
                shutil.rmtree(old_path)

    # Create fresh backup directory
    struct_dir = os.path.join(backup_dir, 'structure')
    data_dir = os.path.join(backup_dir, 'data')
    os.makedirs(struct_dir, exist_ok=True)
    os.makedirs(data_dir, exist_ok=True)

    inspector = inspect(engine)
    tables = sorted(inspector.get_table_names())
    total_rows = 0

    with engine.connect() as conn:
        all_ddl = []

        for tbl in tables:
            # ── Structure (DDL) ──
            result = conn.execute(text(f'SHOW CREATE TABLE `{tbl}`'))
            row = result.fetchone()
            ddl = row[1] + ';'
            all_ddl.append(f'-- Table: {tbl}\n{ddl}\n')

            with open(os.path.join(struct_dir, f'{tbl}.sql'), 'w') as f:
                f.write(f'-- Table: {tbl}\n-- Backup: {now.isoformat()}\n\n{ddl}\n')

            # ── Data (INSERT) ──
            rows = conn.execute(text(f'SELECT * FROM `{tbl}`')).fetchall()
            cols = [c['name'] for c in inspector.get_columns(tbl)]
            col_list = ', '.join(f'`{c}`' for c in cols)

            with open(os.path.join(data_dir, f'{tbl}_data.sql'), 'w') as f:
                f.write(f'-- Data: {tbl}\n-- Rows: {len(rows)}\n-- Backup: {now.isoformat()}\n\n')
                if not rows:
                    f.write('-- (empty table)\n')
                else:
                    for row in rows:
                        vals = ', '.join(sql_val(v) for v in row)
                        f.write(f'INSERT INTO `{tbl}` ({col_list}) VALUES ({vals});\n')

            total_rows += len(rows)
            log.info(f'  ✅ {tbl}: {len(cols)} cols, {len(rows)} rows')

        # Combined DDL file
        header = f'''-- ============================================
-- xMixing Database Backup
-- Day: {day_of_week} ({now.strftime("%A")})
-- Date: {now.isoformat()}
-- Tables: {len(tables)}
-- ============================================

'''
        with open(os.path.join(struct_dir, '00_all_tables.sql'), 'w') as f:
            f.write(header)
            f.write('\n\n'.join(all_ddl))

    # ── Summary file ──
    summary = {
        'backup_folder': folder_name,
        'day_of_week': day_of_week,
        'day_name': now.strftime('%A'),
        'backup_time': now.isoformat(),
        'total_tables': len(tables),
        'total_rows': total_rows,
        'tables': tables,
    }
    import json
    with open(os.path.join(backup_dir, 'backup_info.json'), 'w') as f:
        json.dump(summary, f, indent=2)

    log.info(f'═══ Backup Complete ═══')
    log.info(f'  📁 {folder_name}/')
    log.info(f'  📊 {len(tables)} tables, {total_rows} rows')
    log.info(f'  💾 Structure: {struct_dir}/')
    log.info(f'  💾 Data: {data_dir}/')


if __name__ == '__main__':
    dry_run = '--dry-run' in sys.argv
    try:
        run_backup(dry_run=dry_run)
    except Exception as e:
        log.error(f'Backup FAILED: {e}', exc_info=True)
        sys.exit(1)
