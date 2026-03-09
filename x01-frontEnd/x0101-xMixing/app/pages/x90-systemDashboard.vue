<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { useQuasar } from 'quasar'
import { appConfig } from '~/appConfig/config'
// import VueApexCharts from 'vue3-apexcharts'

const $q = useQuasar()
const { t } = useI18n()

const formatDate = (date: any) => {
  if (!date) return '-'
  const d = new Date(date)
  if (isNaN(d.getTime())) return date
  return d.toLocaleDateString('en-GB')
}

const formatDateTime = (date: any) => {
  if (!date) return '-'
  const d = new Date(date)
  if (isNaN(d.getTime())) return date
  return d.toLocaleString('en-GB')
}

// ── DB Sync State ──
const syncLoading = ref<string | null>(null) // 'cloud-to-remote' | 'remote-to-cloud' | null
const syncLog = ref<string[]>([])
const syncDialog = ref(false)
const dbStatus = ref<any>(null)
const dbStatusLoading = ref(false)

const fetchDbStatus = async () => {
  dbStatusLoading.value = true
  try {
    const data = await $fetch<any>(`${appConfig.apiBaseUrl}/db-sync/status`)
    dbStatus.value = data
  } catch (e) {
    console.error('DB status error:', e)
  } finally {
    dbStatusLoading.value = false
  }
}

const handleSync = async (direction: 'cloud-to-remote' | 'remote-to-cloud') => {
  const label = direction === 'cloud-to-remote'
    ? 'Cloud → Remote'
    : 'Remote → Cloud'

  $q.dialog({
    title: 'Confirm Database Sync',
    message: `Are you sure you want to sync <b>${label}</b>?<br><br>This will <b>overwrite all data</b> on the target database.`,
    html: true,
    cancel: true,
    persistent: true,
    ok: { label: 'Sync Now', color: 'negative', icon: 'sync' },
  }).onOk(async () => {
    syncLoading.value = direction
    syncLog.value = [`Starting sync: ${label}...`]
    syncDialog.value = true

    try {
      const data = await $fetch<any>(`${appConfig.apiBaseUrl}/db-sync/${direction}`, { method: 'POST', timeout: 120000 })
      syncLog.value = data.log || []
      syncLog.value.push(``, `══════════════════════════════`)
      syncLog.value.push(`✅ Sync complete: ${data.tables_synced} tables, ${data.views_synced} views, ${data.total_rows} rows`)

      $q.notify({ type: 'positive', message: `Sync complete: ${label}`, caption: `${data.tables_synced} tables, ${data.total_rows} rows` })
      fetchDbStatus()
    } catch (e: any) {
      syncLog.value.push(`❌ Error: ${e?.data?.detail || e?.message || 'Unknown error'}`)
      $q.notify({ type: 'negative', message: `Sync failed: ${label}`, caption: e?.data?.detail || e?.message })
    } finally {
      syncLoading.value = null
    }
  })
}

onMounted(() => {
  fetchDbStatus()
})

interface MetricPoint {
  timestamp: string
  value: number
}

interface ServerHistory {
  cpu: MetricPoint[]
  memory: MetricPoint[]
  disk: MetricPoint[]
  net_sent: MetricPoint[]
  net_recv: MetricPoint[]
}

interface ServerStatus {
  cpu_percent: number[]
  cpu_average: number
  cpu_count: number
  memory: {
    total: number
    available: number
    percent: number
    used: number
  }
  disk: {
    total: number
    used: number
    free: number
    percent: number
  }
  network: {
    bytes_sent: number
    bytes_recv: number
    packets_sent: number
    packets_recv: number
  }
  boot_time: number
  os: string
  python_version: string
  hostname: string
  local_ip: string
  cpu_model: string
  architecture: string
}

const status = ref<ServerStatus | null>(null)
const history = ref<ServerHistory | null>(null)
const loading = ref(true)
const error = ref<string | null>(null)
let pollTimer: any = null
let historyTimer: any = null

const formatBytes = (bytes: number, decimals = 2) => {
  if (bytes === 0) return '0 Bytes'
  const k = 1024
  const dm = decimals < 0 ? 0 : decimals
  const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i]
}

const fetchStatus = async () => {
  try {
    const response = await fetch(`${appConfig.apiBaseUrl}/server-status`)
    if (!response.ok) throw new Error('Failed to fetch server status')
    status.value = await response.json()
    error.value = null
  } catch (e) {
    console.error(e)
    error.value = (e as any).message
  } finally {
    loading.value = false
  }
}

const fetchHistory = async () => {
  try {
    const response = await fetch(`${appConfig.apiBaseUrl}/server-status/history`)
    if (!response.ok) throw new Error('Failed to fetch server history')
    history.value = await response.json()
  } catch (e) {
    console.error('History fetch error:', e)
  }
}

// Chart Options
const baseChartOptions = {
  chart: {
    type: 'line' as const,
    height: 250,
    animations: { enabled: false },
    toolbar: { show: false },
    zoom: { enabled: false }
  },
  stroke: { curve: 'smooth' as const, width: 2 },
  xaxis: {
    type: 'datetime' as const,
    labels: {
      datetimeUTC: false,
      format: 'HH:mm:ss'
    },
    tooltip: { enabled: false }
  },
  yaxis: {
    labels: { formatter: (val: number) => val.toFixed(1) }
  },
  legend: { position: 'top' as const },
  grid: {
    borderColor: '#f1f1f1',
    show: true
  }
}

const cpuSeries = computed(() => [
  {
    name: 'CPU Usage (%)',
    data: history.value?.cpu.map(p => ({ x: new Date(p.timestamp).getTime(), y: p.value })) || []
  }
])

const memSeries = computed(() => [
  {
    name: 'Memory Usage (%)',
    data: history.value?.memory.map(p => ({ x: new Date(p.timestamp).getTime(), y: p.value })) || []
  }
])

const diskSeries = computed(() => [
  {
    name: 'Disk Usage (%)',
    data: history.value?.disk.map(p => ({ x: new Date(p.timestamp).getTime(), y: p.value })) || []
  }
])

const netSeries = computed(() => [
  {
    name: 'Sent (KB/s)',
    data: history.value?.net_sent.map(p => ({ x: new Date(p.timestamp).getTime(), y: p.value / 1024 })) || []
  },
  {
    name: 'Received (KB/s)',
    data: history.value?.net_recv.map(p => ({ x: new Date(p.timestamp).getTime(), y: p.value / 1024 })) || []
  }
])

onMounted(() => {
  fetchStatus()
  fetchHistory()
  pollTimer = setInterval(fetchStatus, 3000)
  historyTimer = setInterval(fetchHistory, 10000) // History every 10s
})

onUnmounted(() => {
  if (pollTimer) clearInterval(pollTimer)
  if (historyTimer) clearInterval(historyTimer)
})
</script>

<template>
  <q-page class="q-pa-md">
    <ClientOnly>
      <div v-if="status" class="row q-col-gutter-md">
        <div class="col-12">
          <div class="text-h5 flex items-center">
            <q-icon name="dns" class="q-mr-sm" color="primary" />
            {{ t('dashboard.title') }}
            <q-spacer />
            <q-chip color="primary" text-color="white" icon="info" dense>
              {{ status.os }}
            </q-chip>
            <q-chip color="secondary" text-color="white" icon="code" dense>
              Python {{ status.python_version }}
            </q-chip>
          </div>
        </div>

        <!-- Left Pane: PC Info and Uptime -->
        <div class="col-12 col-md-3">
          <div class="column q-gutter-md">
            <!-- PC Info Card -->
            <q-card flat bordered class="bg-primary text-white">
              <q-card-section>
                <div class="text-subtitle1 text-weight-bold flex items-center">
                  <q-icon name="computer" class="q-mr-xs" />
                  {{ t('dashboard.pcInfo') }}
                </div>
              </q-card-section>
              <q-card-section class="q-pt-none">
                <div class="q-mb-sm">
                  <div class="text-caption opacity-70">{{ t('dashboard.hostname') }}</div>
                  <div class="text-subtitle2">{{ status.hostname }}</div>
                </div>
                <div class="q-mb-sm">
                  <div class="text-caption opacity-70">{{ t('dashboard.localIp') }}</div>
                  <div class="text-subtitle2">{{ status.local_ip }}</div>
                </div>
                <div class="q-mb-sm">
                  <div class="text-caption opacity-70">{{ t('dashboard.osKernel') }}</div>
                  <div class="text-subtitle2">{{ status.os }}</div>
                </div>
                <div class="q-mb-sm">
                  <div class="text-caption opacity-70">{{ t('dashboard.architecture') }}</div>
                  <div class="text-subtitle2">{{ status.architecture }}</div>
                </div>
                <div class="q-mb-sm">
                  <div class="text-caption opacity-70">{{ t('dashboard.cpuModel') }}</div>
                  <div class="text-subtitle2 text-italic" style="font-size: 0.8rem">
                    {{ status.cpu_model }}
                  </div>
                </div>
              </q-card-section>
            </q-card>

            <!-- System Uptime Card -->
            <q-card flat bordered class="bg-grey-9 text-white">
              <q-card-section>
                <div class="text-subtitle1 text-weight-bold flex items-center">
                  <q-icon name="history" class="q-mr-xs" />
                  {{ t('dashboard.systemUptime') }}
                </div>
              </q-card-section>
              <q-card-section class="q-pt-none">
                <div class="text-caption text-grey-5">{{ t('dashboard.bootTime') }}</div>
                <div class="text-subtitle2">
                  {{ formatDateTime(status.boot_time * 1000) }}
                </div>
                <q-btn 
                  icon="refresh" 
                  flat 
                  round 
                  dense 
                  @click="fetchStatus" 
                  :loading="loading" 
                  class="q-mt-md full-width"
                  :label="t('dashboard.refreshMetrics')"
                />
              </q-card-section>
            </q-card>

            <!-- Database Sync Card -->
            <q-card flat bordered class="bg-teal-9 text-white">
              <q-card-section>
                <div class="text-subtitle1 text-weight-bold flex items-center">
                  <q-icon name="sync" class="q-mr-xs" />
                  Database Sync
                  <q-spacer />
                  <q-btn flat round dense icon="refresh" size="sm" @click="fetchDbStatus" :loading="dbStatusLoading" />
                </div>
              </q-card-section>
              <q-card-section class="q-pt-none">
                <!-- Connection Status -->
                <div v-if="dbStatus" class="q-mb-md">
                  <div class="q-mb-xs row items-center">
                    <q-icon :name="dbStatus.cloud?.status === 'connected' ? 'cloud_done' : 'cloud_off'" :color="dbStatus.cloud?.status === 'connected' ? 'green-4' : 'red-4'" size="xs" class="q-mr-xs" />
                    <span class="text-caption">Cloud ({{ dbStatus.cloud?.host }})</span>
                    <q-spacer />
                    <q-badge :color="dbStatus.cloud?.status === 'connected' ? 'green' : 'red'" :label="dbStatus.cloud?.status === 'connected' ? `${dbStatus.cloud.tables} tables` : 'offline'" />
                  </div>
                  <div class="row items-center">
                    <q-icon :name="dbStatus.remote?.status === 'connected' ? 'dns' : 'report_problem'" :color="dbStatus.remote?.status === 'connected' ? 'green-4' : 'red-4'" size="xs" class="q-mr-xs" />
                    <span class="text-caption">Remote ({{ dbStatus.remote?.host }})</span>
                    <q-spacer />
                    <q-badge :color="dbStatus.remote?.status === 'connected' ? 'green' : 'red'" :label="dbStatus.remote?.status === 'connected' ? `${dbStatus.remote.tables} tables` : 'offline'" />
                  </div>
                </div>

                <!-- Sync Buttons -->
                <q-btn
                  icon="cloud_upload"
                  label="Remote → Cloud"
                  color="amber-8"
                  class="full-width q-mb-sm"
                  dense
                  no-caps
                  :loading="syncLoading === 'remote-to-cloud'"
                  :disable="!!syncLoading"
                  @click="handleSync('remote-to-cloud')"
                />
                <q-btn
                  icon="cloud_download"
                  label="Cloud → Remote"
                  color="light-blue-8"
                  class="full-width"
                  dense
                  no-caps
                  :loading="syncLoading === 'cloud-to-remote'"
                  :disable="!!syncLoading"
                  @click="handleSync('cloud-to-remote')"
                />
              </q-card-section>
            </q-card>
          </div>
        </div>

        <!-- Sync Log Dialog -->
        <q-dialog v-model="syncDialog" persistent>
          <q-card style="min-width: 500px; max-width: 700px;">
            <q-card-section class="row items-center q-pb-none">
              <div class="text-h6">
                <q-icon name="sync" class="q-mr-xs" />
                Sync Log
              </div>
              <q-spacer />
              <q-btn v-if="!syncLoading" icon="close" flat round dense v-close-popup />
            </q-card-section>
            <q-card-section>
              <q-linear-progress v-if="syncLoading" indeterminate color="primary" class="q-mb-md" />
              <div class="bg-grey-10 text-green-4 q-pa-md rounded-borders" style="font-family: monospace; font-size: 0.8rem; max-height: 400px; overflow-y: auto;">
                <div v-for="(line, i) in syncLog" :key="i" :class="{ 'text-red-4': line.startsWith('✗') || line.startsWith('❌'), 'text-green-4': line.startsWith('✓') || line.startsWith('✅') }">
                  {{ line }}
                </div>
              </div>
            </q-card-section>
            <q-card-actions align="right" v-if="!syncLoading">
              <q-btn flat label="Close" color="primary" v-close-popup />
            </q-card-actions>
          </q-card>
        </q-dialog>

        <!-- Right Content: Metrics and Charts -->
        <div class="col-12 col-md-9">
          <div class="row q-col-gutter-md">
            <!-- CPU Usage -->
            <div class="col-12 col-md-4">
              <q-card flat bordered class="full-height">
                <q-card-section>
                  <div class="text-subtitle1 text-weight-bold flex items-center">
                    <q-icon name="memory" class="q-mr-xs" color="orange" />
                    CPU ({{ status.cpu_count }} Cores)
                  </div>
                </q-card-section>
                <q-card-section class="flex flex-center">
                  <q-circular-progress
                    show-value
                    font-size="16px"
                    :value="status.cpu_average"
                    size="120px"
                    :thickness="0.2"
                    color="orange"
                    track-color="orange-1"
                  >
                    <div class="column items-center">
                      <span class="text-h5 text-weight-bold">{{ status.cpu_average.toFixed(1) }}%</span>
                      <span class="text-caption">Avg</span>
                    </div>
                  </q-circular-progress>
                </q-card-section>
                <q-card-section class="q-pt-none">
                  <div v-for="(p, i) in status.cpu_percent.slice(0, 4)" :key="i" class="q-mb-xs">
                    <div class="row justify-between text-caption">
                      <span>Core {{ i }}</span>
                      <span>{{ p.toFixed(1) }}%</span>
                    </div>
                    <q-linear-progress :value="p / 100" color="orange" rounded />
                  </div>
                  <div v-if="status.cpu_count > 4" class="text-center text-caption text-grey italic q-mt-xs">
                    + {{ status.cpu_count - 4 }} more cores
                  </div>
                </q-card-section>
              </q-card>
            </div>

            <!-- Memory Usage -->
            <div class="col-12 col-md-4">
              <q-card flat bordered class="full-height">
                <q-card-section>
                  <div class="text-subtitle1 text-weight-bold flex items-center">
                    <q-icon name="ram" class="q-mr-xs" color="blue" />
                    {{ t('dashboard.memoryRam') }}
                  </div>
                </q-card-section>
                <q-card-section class="flex flex-center">
                  <q-circular-progress
                    show-value
                    font-size="16px"
                    :value="status.memory.percent"
                    size="120px"
                    :thickness="0.2"
                    color="blue"
                    track-color="blue-1"
                  >
                    <div class="column items-center">
                      <span class="text-h5 text-weight-bold">{{ status.memory.percent.toFixed(1) }}%</span>
                      <span class="text-caption">Used</span>
                    </div>
                  </q-circular-progress>
                </q-card-section>
                <q-card-section class="q-pt-none">
                  <div class="column q-gutter-xs">
                    <div class="row justify-between text-caption">
                      <span class="text-grey-7">Used:</span>
                      <span class="text-weight-bold text-blue">{{ formatBytes(status.memory.used) }}</span>
                    </div>
                    <div class="row justify-between text-caption">
                      <span class="text-grey-7">Total:</span>
                      <span>{{ formatBytes(status.memory.total) }}</span>
                    </div>
                  </div>
                </q-card-section>
              </q-card>
            </div>

            <!-- Disk Usage -->
            <div class="col-12 col-md-4">
              <q-card flat bordered class="full-height">
                <q-card-section>
                  <div class="text-subtitle1 text-weight-bold flex items-center">
                    <q-icon name="storage" class="q-mr-xs" color="purple" />
                    {{ t('dashboard.storageDisk') }}
                  </div>
                </q-card-section>
                <q-card-section class="flex flex-center">
                  <q-circular-progress
                    show-value
                    font-size="16px"
                    :value="status.disk.percent"
                    size="120px"
                    :thickness="0.2"
                    color="purple"
                    track-color="purple-1"
                  >
                    <div class="column items-center">
                      <span class="text-h5 text-weight-bold">{{ status.disk.percent.toFixed(1) }}%</span>
                      <span class="text-caption">Filled</span>
                    </div>
                  </q-circular-progress>
                </q-card-section>
                <q-card-section class="q-pt-none">
                  <div class="column q-gutter-xs">
                    <div class="row justify-between text-caption">
                      <span class="text-grey-7">Free:</span>
                      <span class="text-weight-bold text-purple">{{ formatBytes(status.disk.free) }}</span>
                    </div>
                    <div class="row justify-between text-caption">
                      <span class="text-grey-7">Total:</span>
                      <span>{{ formatBytes(status.disk.total) }}</span>
                    </div>
                  </div>
                </q-card-section>
              </q-card>
            </div>

            <!-- Network Traffic -->
            <div class="col-12">
              <q-card flat bordered>
                <q-card-section>
                  <div class="text-subtitle1 text-weight-bold flex items-center">
                    <q-icon name="swap_calls" class="q-mr-xs" color="green" />
                    {{ t('dashboard.networkTraffic') }}
                  </div>
                </q-card-section>
                <q-card-section class="q-pt-none">
                  <div class="row q-col-gutter-sm">
                    <div class="col-6 col-md-3">
                      <div class="bg-green-1 q-pa-sm rounded-borders">
                        <div class="text-caption text-grey-7">{{ t('dashboard.sent') }}</div>
                        <div class="text-subtitle1 text-weight-bold">{{ formatBytes(status.network.bytes_sent) }}</div>
                      </div>
                    </div>
                    <div class="col-6 col-md-3">
                      <div class="bg-green-1 q-pa-sm rounded-borders">
                        <div class="text-caption text-grey-7">{{ t('dashboard.received') }}</div>
                        <div class="text-subtitle1 text-weight-bold">{{ formatBytes(status.network.bytes_recv) }}</div>
                      </div>
                    </div>
                    <div class="col-6 col-md-3">
                      <div class="bg-blue-grey-1 q-pa-sm rounded-borders">
                        <div class="text-caption text-grey-7">Pkts Sent</div>
                        <div class="text-subtitle1">{{ status.network.packets_sent.toLocaleString() }}</div>
                      </div>
                    </div>
                    <div class="col-6 col-md-3">
                      <div class="bg-blue-grey-1 q-pa-sm rounded-borders">
                        <div class="text-caption text-grey-7">Pkts Recv</div>
                        <div class="text-subtitle1">{{ status.network.packets_recv.toLocaleString() }}</div>
                      </div>
                    </div>
                  </div>
                </q-card-section>
              </q-card>
            </div>

            <!-- History Charts -->
            <div class="col-12 col-md-6">
              <q-card flat bordered>
                <q-card-section class="q-pb-none">
                  <div class="text-subtitle2 text-weight-bold">{{ t('dashboard.cpuHistory') }}</div>
                </q-card-section>
                <q-card-section>
                  <apexchart height="200" :options="baseChartOptions" :series="cpuSeries" />
                </q-card-section>
              </q-card>
            </div>

            <div class="col-12 col-md-6">
              <q-card flat bordered>
                <q-card-section class="q-pb-none">
                  <div class="text-subtitle2 text-weight-bold">{{ t('dashboard.memHistory') }}</div>
                </q-card-section>
                <q-card-section>
                  <apexchart height="200" :options="baseChartOptions" :series="memSeries" />
                </q-card-section>
              </q-card>
            </div>
          </div>
        </div>
      </div>

      <!-- Placeholder content during server render -->
      <template #fallback>
        <div class="flex flex-center" style="height: 80vh">
          <q-spinner-gears size="100px" color="primary" />
          <div class="text-h6 q-ml-md">{{ t('dashboard.loadingMetrics') }}</div>
        </div>
      </template>
    </ClientOnly>
    
    <div v-if="error" class="q-pa-md text-red text-center">
      <q-icon name="error" size="lg" />
      <div class="text-h6">{{ t('dashboard.errorConnecting') }}</div>
      <p>{{ error }}</p>
      <q-btn :label="t('dashboard.retry')" color="primary" @click="fetchStatus" />
    </div>
  </q-page>
</template>

<style scoped>
.full-height {
  height: 100%;
}
.opacity-70 {
  opacity: 0.7;
}
</style>
