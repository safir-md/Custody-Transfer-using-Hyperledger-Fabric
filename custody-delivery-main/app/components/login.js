import Component from '@glimmer/component';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { isEmpty, isPresent } from '@ember/utils';
import { inject as service } from '@ember/service';

const COUNTRIES = [{
  id: 1,
  name: 'Germany',
  flag: 'germany'
}, {
  id: 2,
  name: 'USA',
  flag: 'usa'
}];

const USER_TYPES = [{
  id: 1,
  name: 'Buyer'
}, {
  id: 2,
  name: 'Seller'
}, {
  id: 3,
  name: 'TSP'
}];

export default class LoginComponent extends Component {
  @service router;
  @service request;
  @service toast;
  @tracked username = null;
  @tracked password = null;
  @tracked selectedUserType = this.userTypes[0];

  get canShowCountry() {
    return this.selectedUserType.id !== 3;
  }

  get selectedCountry() {
    if (!this.canShowCountry) {
      return;
    }
    return COUNTRIES.findBy('id', this.selectedUserType.id);
  }

  get userTypes() {
    return USER_TYPES;
  }

  @action
  onUserChange(userType) {
    this.selectedUserType = userType;
    return;
  }

  @action
  performLogin() {
    const isValid = this.validateForm();
    if (isValid) {
      this.request.fetch('/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          username: this.username,
          password: this.password,
          user_type: this.selectedUserType.id
        })
      }).then(() => {
        this.router.transitionTo('app', { queryParams: { userType: this.selectedUserType.id } });
      }).catch((exception = {}) => {
        console.log(exception);
      });
    }
    return;
  }

  validateForm() {
    const { username, password} = this;
    if (isEmpty(username) || isEmpty(password)) {
      this.toast.error('Please fill all the fields');
      return false;
    }
    return true;
  }
}
