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

Ext.define('Asgard.Flarc.Plane.ReferenceField', {
  extend: 'Asgard.form.field.ReferenceField',
  alias: 'widget.flarc_plane',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.Plane',
    'Asgard.Flarc.Plane',
    'Asgard.Flarc.Plane.Picker',
  ],
  asgardObject: 'Asgard.Flarc.Plane',
  pickerClass: 'Asgard.Flarc.Plane.Picker',
});
