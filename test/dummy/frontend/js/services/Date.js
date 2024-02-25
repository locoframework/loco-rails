import { Config, I18n } from "loco-js-model";

class Date {
  constructor(date, locale = Config.locale) {
    this.date = date;
    this.skope = I18n[locale].date;
  }

  toString(format = "default") {
    const skope = this.skope.formats;
    switch (format) {
      case "default":
        return this.strftime(skope.default);
      case "short":
        return this.strftime(skope.short);
      case "long":
        return this.strftime(skope.long);
      default:
        console.log("Services.Date#toString: unknown format.");
    }
  }

  strftime(str) {
    str = str.replace("%Y", this.date.getFullYear());
    str = str.replace("%y", this.date.getFullYear().toString().substr(-2, 2));
    let month = this.date.getMonth() + 1;
    month = month >= 10 ? month : `0${month}`;
    str = str.replace("%m", month);
    str = str.replace("%b", this.skope.abbr_month_names[this.date.getMonth()]);
    str = str.replace("%B", this.skope.month_names[this.date.getMonth()]);
    str = str.replace(
      "%d",
      this.date.getDate() >= 10
        ? this.date.getDate()
        : `0${this.date.getDate()}`
    );
    str = str.replace(
      "%H",
      this.date.getHours() >= 10
        ? this.date.getHours()
        : `0${this.date.getHours()}`
    );
    str = str.replace(
      "%M",
      this.date.getMinutes() >= 10
        ? this.date.getMinutes()
        : `0${this.date.getMinutes()}`
    );
    return str.replace(
      "%S",
      this.date.getSeconds() >= 10
        ? this.date.getSeconds()
        : `0${this.date.getSeconds()}`
    );
  }
}

export default Date;
