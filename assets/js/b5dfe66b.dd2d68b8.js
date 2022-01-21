"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[865],{1829:function(e){e.exports=JSON.parse('{"functions":[{"name":"ClientFunction","desc":"The ClientFunction is the function that is passed onto the client which is run when the button on the Quick Actions section is activated.\\n:::danger\\nRemember that the onStateResult should be opposite of onState if you want a simple boolean button. Otherwise, the button will get stuck in one state.\\n:::","params":[{"name":"onState:","desc":"Passes on the state of the button from the Quick Action interface.","lua_type":"boolean"}],"returns":[{"desc":"The new resultant state which will be passed on to the interface to be displayed.","lua_type":"OnStateResult: boolean"},{"desc":"The argument which will be passed onto the server after this function finishes via KuraRE. If it is nil, KuraRE does not fire.","lua_type":"FireServer: any"}],"function_type":"static","source":{"line":57,"path":"src/shared/ExplorerKuraQuickActions/ExampleQuickActionsModule.lua"}},{"name":"ServerEvent","desc":"The ServerEvent is the function that the server runs if KuraRE is fired in ClientFunction by providing a return value that is not nil.","params":[{"name":"Player:","desc":"Player who initiated the ClientFunction. This is sanity-checked as the Educator.","lua_type":"Player"},{"name":"ExplorerArgs","desc":"Arguments passed on from ExplorerKuraServer. If you are not using QuickActions, use the ExplorerGetters folder.","lua_type":"= {TeleportTargets = {[Player]: TeleportTarget}, MutedPlayers = {[Player]: MutedPlayer}, Locators = {[Player]: LocatorServer},}"},{"name":"ClientArgs:","desc":"Arguments passed on by the user in the ClientFunction.","lua_type":"any"}],"returns":[],"function_type":"static","source":{"line":73,"path":"src/shared/ExplorerKuraQuickActions/ExampleQuickActionsModule.lua"}}],"properties":[{"name":"FriendlyName","desc":"FriendlyName can either be a fixed string or can vary depending on state, where a table with boolean keys and string values is used.","lua_type":"string | {true: string, false: string}","source":{"line":23,"path":"src/shared/ExplorerKuraQuickActions/ExampleQuickActionsModule.lua"}},{"name":"DefaultState","desc":"Specifies the default state which will be passed on to the button in the Quick Action interface.\\n:::caution\\nIf not specified, the DefaultState will be set to false.\\n:::","lua_type":"boolean","source":{"line":33,"path":"src/shared/ExplorerKuraQuickActions/ExampleQuickActionsModule.lua"}},{"name":"Image","desc":"Add an image to the button.\\n:::info\\nIf not specified, a default specified in ExplorerKuraServer(/init.server.lua) is used instead with a warning.\\n:::","lua_type":"Content","source":{"line":43,"path":"src/shared/ExplorerKuraQuickActions/ExampleQuickActionsModule.lua"}}],"types":[],"name":"QuickAction","desc":"Quick Actions provide an interface for the educator to control the experience of the class in your experience. From a single button press on the Quick Actions interface, the Educator can initiate actions to change the Experience.\\n:::note\\nThis module relies on Kura Remote Events.\\n:::","source":{"line":10,"path":"src/shared/ExplorerKuraQuickActions/ExampleQuickActionsModule.lua"}}')}}]);