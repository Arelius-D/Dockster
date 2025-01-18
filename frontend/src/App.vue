<template>
  <div :class="theme">
    <!-- Header -->
    <header class="bg-primary text-white flex justify-between items-center p-4">
      <h1 class="text-2xl font-bold">Dockster Dashboard</h1>
      <button
        class="bg-secondary text-white px-4 py-2 rounded"
        @click="toggleTheme"
      >
        {{ theme === 'dark' ? 'Switch to Light Theme' : 'Switch to Dark Theme' }}
      </button>
    </header>

    <!-- Main Content -->
    <main class="p-6">
      <!-- System Status Section -->
      <section class="mb-6">
        <h2 class="text-xl font-semibold mb-2">System Status</h2>
        <div class="bg-light p-4 rounded shadow">
          <p>Status: {{ systemStatus }}</p>
          <p>Uptime: {{ uptime }}</p>
        </div>
      </section>

      <!-- Logs Section -->
      <section class="mb-6">
        <h2 class="text-xl font-semibold mb-2">Logs</h2>
        <div class="space-x-4">
          <button
            class="bg-primary text-white px-4 py-2 rounded"
            @click="showDockerLogs = !showDockerLogs"
          >
            {{ showDockerLogs ? 'Hide Docker Logs' : 'Show Docker Logs' }}
          </button>
          <button
            class="bg-primary text-white px-4 py-2 rounded"
            @click="showUpdateLogs = !showUpdateLogs"
          >
            {{ showUpdateLogs ? 'Hide Update Logs' : 'Show Update Logs' }}
          </button>
        </div>

        <div v-if="showDockerLogs" class="mt-4">
          <h3 class="font-semibold">Docker Logs</h3>
          <pre
            v-if="dockerLogs"
            class="bg-light p-4 rounded shadow overflow-auto"
          >{{ dockerLogs }}</pre>
          <p v-else>Loading Docker logs...</p>
        </div>

        <div v-if="showUpdateLogs" class="mt-4">
          <h3 class="font-semibold">Update Logs</h3>
          <pre
            v-if="updateLogs"
            class="bg-light p-4 rounded shadow overflow-auto"
          >{{ updateLogs }}</pre>
          <p v-else>Loading Update logs...</p>
        </div>
      </section>

      <!-- Manual Commands Section -->
      <section>
        <h2 class="text-xl font-semibold mb-2">Manual Commands</h2>
        <div class="space-x-4">
          <button
            class="bg-primary text-white px-4 py-2 rounded"
            @click="triggerCommand('apt-get update')"
          >
            Run Update
          </button>
          <button
            class="bg-primary text-white px-4 py-2 rounded"
            @click="triggerCommand('apt-get upgrade -y')"
          >
            Run Upgrade
          </button>
          <button
            class="bg-primary text-white px-4 py-2 rounded"
            @click="triggerCommand('apt-get autoremove -y')"
          >
            Clean Packages
          </button>
        </div>
      </section>
    </main>
  </div>
</template>

<script>
export default {
  name: 'App',
  data() {
    return {
      theme: 'dark',
      systemStatus: 'Healthy',
      uptime: '5 days, 3 hours',
      showDockerLogs: false,
      showUpdateLogs: false,
      dockerLogs: '',
      updateLogs: ''
    };
  },
  methods: {
    toggleTheme() {
      this.theme = this.theme === 'dark' ? 'light' : 'dark';
    },
    fetchDockerLogs() {
      fetch('/api/logs')
        .then((response) => response.json())
        .then((data) => {
          if (data.logs) {
            this.dockerLogs = data.logs.join('\n');
          } else {
            this.dockerLogs = 'No Docker logs available.';
          }
        })
        .catch((error) => {
          console.error('Error fetching Docker logs:', error);
          this.dockerLogs = 'Error fetching Docker logs.';
        });
    },
    fetchUpdateLogs() {
      fetch('/api/logs/update')
        .then((response) => response.json())
        .then((data) => {
          if (data.logs) {
            this.updateLogs = data.logs.join('\n');
          } else {
            this.updateLogs = 'No Update logs available.';
          }
        })
        .catch((error) => {
          console.error('Error fetching Update logs:', error);
          this.updateLogs = 'Error fetching Update logs.';
        });
    },
    triggerCommand(command) {
      fetch('/api/trigger', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ command })
      })
        .then((response) => response.json())
        .then((data) => {
          alert(data.status || data.error);
        })
        .catch((error) => {
          console.error('Error triggering command:', error);
          alert('Error triggering command.');
        });
    }
  },
  watch: {
    showDockerLogs(newValue) {
      if (newValue && !this.dockerLogs) {
        this.fetchDockerLogs();
      }
    },
    showUpdateLogs(newValue) {
      if (newValue && !this.updateLogs) {
        this.fetchUpdateLogs();
      }
    }
  }
};
</script>

<style scoped>
body {
  font-family: 'Open Sans', Arial, sans-serif;
}
.bg-primary {
  background-color: #007bff;
}
.bg-secondary {
  background-color: #0056b3;
}
.bg-light {
  background-color: #f4f4f4;
}
</style>
