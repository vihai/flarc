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

Ext.define('Asgard.Flarc.PlaneType.Configuration.ReferenceField', {
  extend: 'Asgard.form.field.ReferenceField',
  alias: 'widget.flarc_planetypeconfiguration',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.PlaneType',
    'Asgard.Flarc.PlaneType.Configuration',
    'Asgard.Flarc.PlaneType.Configuration.Picker',
  ],
  asgardObject: 'Asgard.Flarc.PlaneType.Configuration',
});
