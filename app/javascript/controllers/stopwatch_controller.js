import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { startedAt: String, stopped: Boolean }
  static targets = ["timer"]

  connect() {
    if (this.stoppedValue || !this.startedAtValue) return
    this.startTime = new Date(this.startedAtValue)
    this.updateTimer()
    this.interval = setInterval(() => this.updateTimer(), 1000)
  }

  disconnect() {
    clearInterval(this.interval)
  }

  updateTimer() {
    const now = new Date()
    const diff = Math.floor((now - this.startTime) / 1000)
    const hours = Math.floor(diff / 3600)
    const minutes = Math.floor((diff % 3600) / 60)
    const seconds = diff % 60
    this.timerTarget.textContent = `${hours}h ${minutes}m ${seconds}s`
  }
}
