import Controller from '@ember/controller';

export default class AppController extends Controller {
  queryParams = ['userType'];
  userType = null;
}