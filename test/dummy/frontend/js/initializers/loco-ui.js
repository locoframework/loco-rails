import { Config, I18n } from "loco-js-model";
import { connect } from "loco-js-ui";
import loco from "./loco";

connect({
  getLocale: () => Config.locale,
  loco,
  I18n,
});
