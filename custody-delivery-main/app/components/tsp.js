import Component from '@glimmer/component';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { inject as service } from '@ember/service';
import { isEmpty } from '@ember/utils';

export default class TspComponent extends Component {
  @service request;
  @service toast;
  @tracked isLoading = false;
  @tracked blockedQuantity = null;
  @tracked newLocation = null;

  @action
  loadData() {
    this.isLoading = true;
    this.request.fetch('/blocked_qty').then((data) => {
      this.blockedQuantity = data;
    }).catch((exception) => {
      console.log(exception);
    }).finally(() => {
      this.isLoading = false;
    });;
  }

  @action
  performSubmit() {
    const isValid = this.validate();
    if (!isValid) return;
    this.request.fetch('/update_location', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        location: this.newLocation
      })
    }).then(() => {
      this.toast.success('Location updated successfully!');
      this.newLocation = null;
    }).catch((exception) => {
      console.log(exception);
    });
  }

  validate () {
    if (isEmpty(this.newLocation)) {
      this.toast.error('Please enter the location to update');
      return false;
    }
    return true;
  }
}
