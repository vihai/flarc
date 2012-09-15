/*
 * Copyright (C) 2008-2012, Intercom Srl, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *          Lele Forzani <lele@windmill.it>
 *          Alfredo Cerutti <acerutti@intercom.it>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Asgard.Flarc.Pilot.CollectionField', {
  extend: 'Asgard.form.field.CollectionView',
  requires: [
    'Asgard.Core.Plugin',
    'Flarc.Pilot',
    'Asgard.Flarc.Pilot.Picker',
  ],
  alias: 'widget.flarc_pilots',

  dataview: {
    xtype: 'objectview',
    multiSelect: true,
    tpl: [
      '<tpl for=".">',
        '<div class="item asgard_object">',
          '{name.first} {name.last}<br/> ',
          '<b>{italian_fiscal_code}</b>',
        '</div>',
      '</tpl>',
    ],
    store: {
      model: 'Flarc.Pilot',
    },
  },

  picker: {
    xtype: 'flarc_pilot_picker',
  },
});
