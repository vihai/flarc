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

Ext.define('Asgard.Flarc.Flight', {
  extend: 'Asgard.Object',
  requires: [
    'Asgard.Flarc.Plugin',
  ],
  singleton: true,
  model: 'Flarc.Flight',

  subTpl: [
    '{name}<br/> ',
    '<b>{vat_number}</b>',
  ],
});
