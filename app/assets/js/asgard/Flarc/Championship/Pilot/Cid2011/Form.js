/*
 * Copyright (C) 2012-2012, Intercom Srl, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *          Lele Forzani <lele@windmill.it>
 *          Alfredo Cerutti <acerutti@intercom.it>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Asgard.Flarc.Championship.Pilot.Cid2011.Form', {
  extend: 'Asgard.form.ModelFormPanel',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.Championship',
  ],
  model: 'Flarc.Chapionship.Pilot',
  record: {
    _type: 'Flarc::Championship::Pilot::Cid2011',
  },

  items: [
   {
    xtype: 'combobox',
    fieldLabel: 'Category',
    name: 'cid_category',
    width: 370,
    queryMode: 'local',
    store: [
     [ 'prom', 'Promozione' ],
     [ 'naz', 'Nazionale' ],
    ],
   },
  ],
});
