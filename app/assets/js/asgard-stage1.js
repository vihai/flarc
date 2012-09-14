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

//= require asgard-common-stage1

Ext.Loader.setConfig({
  enabled: true,
  paths: {
    'Ext': '/assets/ext/src',
    'Ext.ux': '/assets/ux',
    'Asgard': '/assets/asgard',
    'Ygg': { handler: 'automodel', path: '/ygg' },
    'Flarc': { handler: 'automodel', path: '/flarc' },
  },
});

