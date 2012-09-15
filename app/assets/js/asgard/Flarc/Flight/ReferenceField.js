/*
 * Copyright (C) 2008-2011, Intercom Srl, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *          Lele Forzani <lele@windmill.it>
 *          Alfredo Cerutti <acerutti@intercom.it>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Asgard.Flarc.Flight.ReferenceField', {
  extend: 'Asgard.form.field.ReferenceField',
  alias: 'widget.flarc_flight',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.Flight',
    'Asgard.Flarc.Flight.Picker'
  ],
  model: 'Ygg.Flarc.Flight',
  tpl: '<tpl for="."><div class="asgard_object">{id}</div></tpl>',
  pickerClass: 'Asgard.Flarc.Flight.Picker',
});
