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

Ext.define('Asgard.Flarc.PlaneType.ReferenceField', {
  extend: 'Asgard.form.field.ReferenceField',
  alias: 'widget.flarc_planetype',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.PlaneType',
    'Asgard.Flarc.PlaneType',
    'Asgard.Flarc.PlaneType.Picker',
  ],
  asgardObject: 'Asgard.Flarc.PlaneType',
  pickerClass: 'Asgard.Flarc.PlaneType.Picker',
});
