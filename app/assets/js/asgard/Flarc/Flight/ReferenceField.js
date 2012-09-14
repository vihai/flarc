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

Ext.define('Asgard.Core.Person.ReferenceField', {
  extend: 'Asgard.form.field.ReferenceField',
  alias: 'widget.core_person',
  requires: [
    'Asgard.Flarc.Plugin',
    'Ygg.Core.Person',
    'Asgard.Core.Person.Picker'
  ],
  model: 'Ygg.Core.Person',
  tpl: '<tpl for="."><div class="asgard_object">{name.first} {name.last}</div></tpl>',
  pickerClass: 'Asgard.Core.Person.Picker',
});
