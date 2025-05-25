import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    startedAt: String,
    stoppedAt: String,
    timerId: Number
  }

  static targets = ["timer"]

  connect() {
    this.startTime = new Date(this.startedAtValue)
    this.stopTime = new Date(this.stoppedAtValue)

    if (Date.now() >= this.stopTime.getTime()) return this.finish()

    this.updateTimer()
    this.interval = setInterval(() => this.updateTimer(), 1000)
  }

  disconnect() {
    clearInterval(this.interval)
  }

  updateTimer() {
    const now = new Date()
    const remaining = Math.max(0, Math.ceil((this.stopTime - now) / 1000))

    const hours = Math.floor(remaining / 3600)
    const minutes = Math.floor((remaining % 3600) / 60)
    const seconds = remaining % 60
    this.timerTarget.textContent = `${hours}h ${minutes}m ${seconds}s`

    if (remaining <= 0) this.finish()
  }

  finish() {
    clearInterval(this.interval)

    fetch(`/timers/${this.timerIdValue}/stop`, {
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Accept': 'text/vnd.turbo-stream.html'
      }
    })
    .then(response => response.text())
    .then(html => {
      const template = document.createElement('template')
      template.innerHTML = html.trim()
      const streams = template.content.querySelectorAll('turbo-stream')
      streams.forEach(stream => document.body.appendChild(stream))
    })
  }
}
