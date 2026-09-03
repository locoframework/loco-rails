import { Models } from "loco-js-model";
import { Reactive } from "simplicit";

const { Base } = Models;

// A loco-js-model that is also a Simplicit Model: the server round-trips stay
// loco's, the in-memory collection and re-rendering are Simplicit's.
class LocoReactive extends Reactive(Base) {
  static getIdentity() {
    return this.identity ?? this.name;
  }

  static async all(...args) {
    const records = await super.all(...args);
    return this.load(records);
  }

  async save(partial = {}) {
    const isCreate = this.id == null;
    const target = isCreate ? this : this.clone();
    for (const [key, val] of Object.entries(partial))
      target.assignAttr(key, val);
    if (target.isInvalid()) return { success: false, errors: target.errors };

    const resp = await Base.prototype.save.call(target);
    if (!resp.success) return resp;

    if (isCreate) {
      this.id = resp.id;
      this.constructor.add(this);
    } else {
      this.update(partial);
    }
    return resp;
  }

  async delete(...args) {
    const resp = await super.delete(...args);
    if (resp.success) this.del();
    return resp;
  }

  update(partial = {}) {
    for (const [key, val] of Object.entries(partial)) this.assignAttr(key, val);
    return this.rerender();
  }

  applyChanges(...args) {
    super.applyChanges(...args);
    return this.rerender();
  }
}

export default LocoReactive;
