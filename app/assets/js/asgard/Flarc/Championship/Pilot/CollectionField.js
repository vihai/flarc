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

Ext.define('Asgard.Flarc.Championship.Pilot.CollectionField', {
  extend: 'Asgard.form.field.CollectionView',
  requires: [
    'Asgard.Flarc.Plugin',
    'Asgard.PolymorphicView',
    'Flarc.Championship',
    'Asgard.Flarc.Championship.Pilot.Cid2011.Form',
    'Asgard.Flarc.Championship.Pilot.Cid2012.Form',
    'Asgard.Flarc.Championship.Pilot.Csvva2009.Form',
    'Asgard.Flarc.Championship.Pilot.Csvva2010.Form',
    'Asgard.Flarc.Championship.Pilot.Csvva2011.Form',
  ],
  alias: 'widget.flarc_championshippilots',

  model: 'Flarc.Championship.Pilot',

  dataview: {
    xtype: 'polyview',
    multiSelect: true,
    perTypeTpl: {
      null: [
        '<b>{_type}</b><br />',
      ],
      'Flarc::Championship::Pilot::Csvva2009': [
        '<b>CSVVA 2009</b><br />',
        '{csvva_pilot_level}',
      ],
      'Flarc::Championship::Pilot::Csvva2010': [
        '<b>CSVVA 2010</b><br />',
        '{csvva_pilot_level}',
      ],
      'Flarc::Championship::Pilot::Csvva2011': [
        '<b>CSVVA 2011</b><br />',
        '{csvva_pilot_level}',
      ],
      'Flarc::Championship::Pilot::Cid2011': [
        '<b>CID 2011</b> - {cid_ranking}<br />',
        '{cid_category}',
      ],
      'Flarc::Championship::Pilot::Cid2012': [
        '<b>CID 2012</b> - {cid_ranking}<br />',
        '{cid_category}',
      ],
    },

    store: {
      model: 'Flarc.Championship.Pilot',
    },
  },

  enableBuiltinAddButton: false,
  toolbarItems: [
   {
    icon: '/assets/add.png',
    text: 'Add',
    menu: {
      items: [
        { text: 'CID 2012', name: 'add-cid2012' },
      ]
    }
   },
  ],

  getFormForRecord: function(record, opts) {
    var formClass = opts ? opts.formClass : null;

    if (record) {
      var forms = {
        'Flarc::Championship::Pilot::Csvva2009': 'Asgard.Flarc.Championship.Pilot.Csvva2009.Form',
        'Flarc::Championship::Pilot::Csvva2010': 'Asgard.Flarc.Championship.Pilot.Csvva2010.Form',
        'Flarc::Championship::Pilot::Csvva2011': 'Asgard.Flarc.Championship.Pilot.Csvva2011.Form',
        'Flarc::Championship::Pilot::Cid2011': 'Asgard.Flarc.Championship.Pilot.Cid2011.Form',
        'Flarc::Championship::Pilot::Cid2012': 'Asgard.Flarc.Championship.Pilot.Cid2012.Form',
      };

      formClass = forms[record.get('_type')];
    }

    return Ext.create(formClass, {
      standalone: false,
      frame: false,
      border: false,
      buttons: [
       { text: 'Ok', name: 'ok' },
       { text: 'Cancel', name: 'cancel' },
      ]
    });
  },

  initComponent: function() {
    var me = this;

    me.callParent(arguments);

    me.toolbar.down('menuitem[name=add-cid2012]').on('click', function() {
      me.onAddRecord({ formClass: 'Asgard.Flarc.Championship.Pilot.Cid2012.Form' });
    });
  },

});
