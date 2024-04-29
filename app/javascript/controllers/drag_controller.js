import { Controller } from "@hotwired/stimulus"
import { Sortable } from "@shopify/draggable"

export default class extends Controller {
  connect() {
    this.sortable = new Sortable(this.element, {
      draggable: ".task"
    });

    this.sortable.on('sortable:stop', (event) => this.onDragEnd(event));
  }

  onDragEnd(event) {
    const item = event.data.dragEvent.data.source;
    const newStatus = item.parentElement.id;
    const taskId = item.dataset.id;

    // Send a fetch request to update the task status
    fetch(`/tasks/${taskId}`, {
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
        'Content-Type': 'application/json',
        'Accept': 'text/vnd.turbo-stream.html',
      },
      body: JSON.stringify({ task: { status: newStatus } })
    })
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.text();
    })
    .then(html => {
      Turbo.renderStreamMessage(html);
    })
    .catch(error => {
      console.error('Error:', error);
    });
  }
}
