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

Ext.define('Asgard.Flarc.PlaneType.Configuration', {
  extend: 'Asgard.Object',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.PlaneType',
  ],
  singleton: true,

  model: 'Flarc.PlaneType.Configuration',

  subTpl: [
    '<b>{name}</b><br/> ',
    '{handicap} <tpl if="club_handicap">(club {club_handicap})</tpl>',
  ],
});
