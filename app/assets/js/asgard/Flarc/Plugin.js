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

Ext.define('Asgard.Flarc.Plugin', {
  extend: 'Asgard.Plugin',

  css: '/assets/flarc-asgard.css',

  init: function() {
    var me = this;

    this.callParent(arguments);

//    me.control({
//      'viewport > tabpanel > panel[klass=Asgard.Core.Organization.IndexPanel] > panel > toolbar button[name=new]':
//       { click: function() { me.openUri('ygg/core/organizations/new'); } },
//
//      'viewport > tabpanel > panel[klass=Asgard.Core.Person.IndexPanel] > panel > toolbar button[name=new]':
//       { click: function() { me.openUri('ygg/core/people/new'); } },
//
//      'viewport > tabpanel > panel[klass=Asgard.Core.Identity.IndexPanel] > panel > toolbar button[name=new]':
//       { click: function() { me.openUri('ygg/core/identities/new'); } },
//
//      'viewport > tabpanel > panel[klass=Asgard.Core.Group.IndexPanel] > panel > toolbar button[name=new]':
//       { click: function() { me.openUri('ygg/core/groups/new'); } },
//
//      'viewport > tabpanel > panel[klass=Asgard.Core.Capability.IndexPanel] > panel > toolbar button[name=new]':
//       { click: function() { me.openUri('ygg/core/capabilities/new'); } },
//    });
  },
});
