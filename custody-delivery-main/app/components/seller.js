import Component from '@glimmer/component';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { inject as service } from '@ember/service';
import { isEmpty } from '@ember/utils';

export default class SellerComponent extends Component {
  @service request;
  @service toast;
  @tracked isLoading = false;
  @tracked assetData = null;
  @tracked historyData = null;
  @tracked reloadQuantity = null;

  @action
  loadData() {
    this.loadAssetData();
    this.loadHistory();
  }

  @action
  performSubmit() {
    const isValid = this.validate();
    if (!isValid) return;
    this.request.fetch('/reload_qty', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        quantity: this.reloadQuantity
      })
    }).then(() => {
      this.toast.success('Quantity updated successfully!');
      this.reloadQuantity = null;
    }).catch((exception) => {
      console.log(exception);
    })
  }

  loadAssetData() {
    this.isLoading = true;
    this.request.fetch('/display_asset').then((data) => {
      this.assetData = data;
    }).catch((exception) => {
      console.log(exception);
    }).finally(() => {
      this.isLoading = false;
    });;
  }

  loadHistory() {
    this.isLoading = true;
    this.request.fetch('/get_history').then((data) => {
      this.historyData = data;
    }).catch((exception) => {
      console.log(exception);
    }).finally(() => {
      this.isLoading = false;
    });;
  }

  validate () {
    if (isEmpty(this.reloadQuantity)) {
      this.toast.error('Please enter the quantity');
      return false;
    }
    return true;
  }
}
