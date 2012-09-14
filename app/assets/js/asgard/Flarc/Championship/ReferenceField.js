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

Ext.define('Asgard.Flarc.Championship.ReferenceField', {
  extend: 'Asgard.form.field.ReferenceField',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.Championship',
    'Asgard.Flarc.Championship',
    'Asgard.Flarc.Championship.Picker',
  ],
  alias: 'widget.flarc_championship',

  asgardObject: 'Asgard.Flarc.Championship',
  pickerClass: 'Asgard.Flarc.Championship.Picker',
});
