import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const browserTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone

    if (!browserTimezone || this.cookieTimezone() === browserTimezone) {
      return
    }

    document.cookie = `timezone=${encodeURIComponent(browserTimezone)}; path=/; max-age=31536000; SameSite=Lax`
    window.location.reload()
  }

  cookieTimezone() {
    const timezoneCookie = document.cookie
      .split("; ")
      .find((entry) => entry.startsWith("timezone="))

    return timezoneCookie ? decodeURIComponent(timezoneCookie.split("=")[1]) : null
  }
}
