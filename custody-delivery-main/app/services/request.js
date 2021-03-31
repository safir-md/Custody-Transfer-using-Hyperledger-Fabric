import Service from '@ember/service';
import { inject as service } from '@ember/service';
import { isPresent } from '@ember/utils';

export default class RequestService extends Service {
  @service toast;

  fetch(url, params) {
    const host = 'http://localhost:3000';
    return fetch(`${host}${url}`, params)
    .then(response => {
      if (!response.ok) {
        throw response;
      }
      return response.json();
    }).catch((exception) => {
      exception.json().then((errorObj) => {
        const { error } = errorObj;
        if (isPresent(error)) {
          this.toast.error(error);
        } else {
          this.toast.error('Something went wrong');
        }
      });
      throw new Error('Something went wrong');
    });
  }
}
