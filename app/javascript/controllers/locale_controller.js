import { Controller } from "@hotwired/stimulus"
/*
  Purpose:
  Hides the display on a target so that it doesn't display.

  Use for this app is to hide the submit button on the locale
  switcher form if JavaScript is enabled

  Connects to data-controller="locale"
*/
export default class extends Controller {
  static targets = [ "submit" ]

  initialize() {
    this.submitTarget.style.display = 'none'
  }
}
