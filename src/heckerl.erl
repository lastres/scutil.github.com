
-module(heckerl).

-author("John Haugeland - stonecypher@gmail.com").
-webpage("http://scutil.com/").
-license( {mit_license, "http://scutil.com/license.html"} ).

-publicsvn("svn://crunchyd.com/scutil/").
-bugtracker(none).
-publicforum(none).

-svn_id("$Id$").
-svn_head("$HeadURL$").
-svn_revision("$Revision$").

-description("Stochastic test counterverification a la Ruby's Heckle.").

-testerl_export( { [], heckerl_testsuite } ).





-export( [

    is_pure/2, is_pure/3, is_pure/4

] ).





is_pure(Module, Function) ->
    is_pure_clauselist(Module, Function, lists:flatten([ ClauseList || { _Id, Func, _Ar, ClauseList } <- scutil:abstract_function(Module, Function), Func==Function ])).

is_pure(Module, Function, Arities) when is_list(Arities) ->
    is_pure_clauselist(Module, Function, lists:flatten([ ClauseList || { _Id, Func, Ar, ClauseList } <- scutil:abstract_function(Module, Function),  Func==Function, lists:member(Ar,Arities) ]));

is_pure(Module, Function, Arity) ->
    is_pure_clauselist(Module, Function, lists:flatten([ ClauseList || { _Id, Func, Ar, ClauseList } <- scutil:abstract_function(Module, Function),  Func==Function, Ar==Arity ])).

is_pure(Module, FunctionID, Function, Arity) ->
    is_pure_clauselist(Module, Function, lists:flatten([ ClauseList || {  Id, Func, Ar, ClauseList } <- scutil:abstract_function(Module, Function),  Func==Function, Id==FunctionID, Ar==Arity ])).