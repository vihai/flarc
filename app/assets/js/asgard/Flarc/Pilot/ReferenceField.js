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

Ext.define('Asgard.Flarc.Pilot.ReferenceField', {
  extend: 'Asgard.form.field.ReferenceField',
  requires: [
    'Asgard.Core.Plugin',
    'Flarc.Pilot',
    'Asgard.Flarc.Pilot',
    'Asgard.Flarc.Pilot.Picker',
  ],
  alias: 'widget.flarc_pilot',

  asgardObject: 'Asgard.Flarc.Pilot',
  pickerClass: 'Asgard.Flarc.Pilot.Picker',
});
