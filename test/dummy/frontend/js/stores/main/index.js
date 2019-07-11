import { createStore } from "redux";

import reducer from "reducers/main";

const store = createStore(reducer, { articles: [] });

export default store;
