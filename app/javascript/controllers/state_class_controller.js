import { Controller } from "@hotwired/stimulus"

const stateClasses = {
  pending: "bg-yellow-200 text-yellow-800",
  processing: "bg-blue-200 text-blue-800",
  completed: "bg-green-200 text-green-800",
  failed: "bg-red-200 text-red-800"
}

export default class extends Controller {
  static targets = ["state"]
  static values = { state: String }

  connect() {
    this.updateStateClass()
  }

  updateStateClass() {
    const cssClass = this.getClassForState()
    this.applyClass(cssClass)
  }

  getClassForState() {
    return stateClasses[this.stateValue] || "bg-gray-200 text-gray-800"
  }

  applyClass(cssClass) {
    this.stateTarget.classList.add(...cssClass.split(' '))
  }
}
