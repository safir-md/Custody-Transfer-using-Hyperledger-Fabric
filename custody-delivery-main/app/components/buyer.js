import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { inject as service } from '@ember/service';
import { isEmpty } from '@ember/utils';

export default class BuyerComponent extends Component {
  @service toast;
  @service request;
  @tracked quantity = 0;
  @tracked globalCertificate = null;
  @tracked localCertificate = null;

  @action
  performSubmit() {
    const isValid = this.validateForm();
    if (isValid) {
      this.request.fetch('/place_order', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          quantity: this.quantity,
          global_certificate: this.globalCertificate,
          local_certificate: this.localCertificate
        })
      }).then(() => {
        this.toast.success('Product added successfully!');
        this.quantity = null;
        this.globalCertificate = null;
        this.localCertificate = null;
      }).catch((exception) => {
        console.log(exception);
      });
    }
    return;     
  }

  validateForm() {
    const { quantity, globalCertificate, localCertificate } = this;
    if (isEmpty(quantity) || isEmpty(globalCertificate) || isEmpty(localCertificate)) {
      this.toast.error('Please fill all the required fields');
      return false;
    }
    return true;
  }
}
