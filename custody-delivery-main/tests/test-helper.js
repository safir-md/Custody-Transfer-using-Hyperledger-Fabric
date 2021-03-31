import Application from 'custody-delivery/app';
import config from 'custody-delivery/config/environment';
import { setApplication } from '@ember/test-helpers';
import { start } from 'ember-qunit';

setApplication(Application.create(config.APP));

start();
