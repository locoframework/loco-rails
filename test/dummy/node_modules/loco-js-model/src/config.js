class Configurator {
  constructor() {
    this.localeVar = "en";
    this.protocolWithHostVar = null;
    this.scopeVar = null;
  }

  get locale() {
    return this.localeVar;
  }

  set locale(val) {
    this.localeVar = val;
    return this.localeVar;
  }

  get protocolWithHost() {
    return this.protocolWithHostVar;
  }

  set protocolWithHost(val) {
    if (!val) {
      this.protocolWithHostVar = null;
      return this.protocolWithHostVar;
    }
    if (val[val.length - 1] === "/") {
      this.protocolWithHostVar = val.slice(0, val.length - 1);
      return this.protocolWithHostVar;
    }
    this.protocolWithHostVar = val;
    return this.protocolWithHostVar;
  }

  get scope() {
    return this.scopeVar;
  }

  set scope(val) {
    this.scopeVar = val;
    return this.scopeVar;
  }
}

const Config = new Configurator();

export default Config;
