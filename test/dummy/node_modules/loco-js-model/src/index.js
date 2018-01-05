import Base from './base.coffee';
import IdentityMap from './identity_map.coffee';
import BaseValidator from './validators/base.coffee';
import Validators from './validators.js';
import Config from './config';
import I18n from './i18n';
import Models from './models';

Validators.Base = BaseValidator;

Models.Base = Base;

export {
  Base,
  Config,
  I18n,
  IdentityMap,
  Models,
  Validators
};