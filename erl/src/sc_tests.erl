
%% @author John Haugeland <stonecypher@gmail.com>
%% @copyright 2011 John Haugeland
%% @version $Revision$
%% @doc scutil test set.

-module(sc_tests).
-compile(export_all).
-include_lib("eqc/include/eqc.hrl").
-include_lib("eunit/include/eunit.hrl").





extrema_test_() ->

    { "Extrema tests", [

        {"8,6,7,5,3,0,9",      ?_assert( {0,9}      =:= sc:extrema( [8,6,7,5,3,0,9] ) ) },
        {"1,2,3,4",            ?_assert( {1,4}      =:= sc:extrema( [1,2,3,4]       ) ) },
        {"-1,-2,-3",           ?_assert( {-3,-1}    =:= sc:extrema( [-1,-2,-3]      ) ) },
        {"-1.1,0,1.1",         ?_assert( {-1.1,1.1} =:= sc:extrema( [-1.1,1.1]      ) ) },
        {"a,b,c",              ?_assert( {a,c}      =:= sc:extrema( [a,b,c]         ) ) },
        {"1,a,{}",             ?_assert( {1,{}}     =:= sc:extrema( [1,a,{}]        ) ) },
        {"1",                  ?_assert( {1,1}      =:= sc:extrema( [1]             ) ) },

        {"[] error undefined", ?_assertError(function_clause, sc:extrema([]) ) }

    ] }.




prop_key_duplicate_correct_length() ->

    ?FORALL( {L,I}, {non_neg_int(), int()}, abs(L) == length( sc:key_duplicate([ {abs(L),I} ]) ) ).





non_neg_int() ->

    ?SUCHTHAT(I, int(), I > 0).





pos_int() ->

    ?SUCHTHAT(I, int(), I > 0).





key_duplicate_test_() ->

    { "Key duplicate tests", [

        {"[ ]",                        ?_assert( []          =:= sc:key_duplicate([ ])             ) },
        {"[ {2,a} ]",                  ?_assert( [a,a]       =:= sc:key_duplicate([ {2,a} ])       ) },
        {"[ {2,a},{3,b} ]",            ?_assert( [a,a,b,b,b] =:= sc:key_duplicate([ {2,a},{3,b} ]) ) },

        {"Stochastic: correct length", ?_assert( true        =:= eqc:quickcheck(prop_key_duplicate_correct_length()) ) }

    ] }.





rotate_list_test_() ->

    { "Rotate list tests", [

        {"0,  [ ]",       ?_assert( []      =:= sc:rotate_list(0,  [ ])       ) },
        {"1,  [ ]",       ?_assert( []      =:= sc:rotate_list(1,  [ ])       ) },
        {"-1, [ ]",       ?_assert( []      =:= sc:rotate_list(-1, [ ])       ) },

        {"0,  [ a,b,c ]", ?_assert( [a,b,c] =:= sc:rotate_list(0,  [ a,b,c ]) ) },
        {"1,  [ a,b,c ]", ?_assert( [b,c,a] =:= sc:rotate_list(1,  [ a,b,c ]) ) },
        {"-1, [ a,b,c ]", ?_assert( [c,a,b] =:= sc:rotate_list(-1, [ a,b,c ]) ) },
        {"3,  [ a,b,c ]", ?_assert( [a,b,c] =:= sc:rotate_list(3,  [ a,b,c ]) ) },
        {"-3, [ a,b,c ]", ?_assert( [a,b,c] =:= sc:rotate_list(-3, [ a,b,c ]) ) },
        {"9,  [ a,b,c ]", ?_assert( [a,b,c] =:= sc:rotate_list(9,  [ a,b,c ]) ) }

    ] }.





index_of_first_test_() ->

    { "Index of first tests", [

        {"0, [ ]",       ?_assert( undefined =:= sc:index_of_first(0, [ ])       ) },
        {"b, [ a,b,c ]", ?_assert( 2         =:= sc:index_of_first(b, [ a,b,c ]) ) },
        {"g, [ a,b,c ]", ?_assert( undefined =:= sc:index_of_first(g, [ a,b,c ]) ) }

    ] }.





rotate_to_first_test_() ->

    { "Rotate to first tests", [

        {"3, [1,2,3,4]", ?_assert( [3,4,1,2] =:= sc:rotate_to_first( 3, [1,2,3,4]  ) ) },
        {"4, [1,2,3,4]", ?_assert( [4,1,2,3] =:= sc:rotate_to_first( 4, [1,2,3,4]  ) ) },
        {"1, [1,2,3,4]", ?_assert( [1,2,3,4] =:= sc:rotate_to_first( 1, [1,2,3,4]  ) ) },

        {"f, [1,2,3,4]", ?_assert( no_such_element =:= sc:rotate_to_first( f, [1,2,3,4]  ) ) }

    ] }.





rotate_to_last_test_() ->

    { "Rotate to last tests", [

        {"3, [1,2,3,4]", ?_assert( [4,1,2,3] =:= sc:rotate_to_last( 3, [1,2,3,4]  ) ) },
        {"1, [1,2,3,4]", ?_assert( [2,3,4,1] =:= sc:rotate_to_last( 1, [1,2,3,4]  ) ) },
        {"4, [1,2,3,4]", ?_assert( [1,2,3,4] =:= sc:rotate_to_last( 4, [1,2,3,4]  ) ) },

        {"f, [1,2,3,4]", ?_assert( no_such_element =:= sc:rotate_to_last( f, [1,2,3,4]  ) ) }

    ] }.





flag_sets_test_() ->

    { "Flag sets tests", [

        {"[1,2,3]",  ?_assert( [[],[3],[2],[2,3],[1],[1,3],[1,2],[1,2,3]]  =:= sc:flag_sets( [1,2,3] )  ) },
        {"[1]",      ?_assert( [[],[1]]                                    =:= sc:flag_sets( [1] )      ) },
        {"[]",       ?_assert( [[]]                                        =:= sc:flag_sets( [] )       ) },
        {"[{[{}]}]", ?_assert( [[],[{[{}]}]]                               =:= sc:flag_sets( [{[{}]}] ) ) }

    ] }.





member_sets_test_() ->

    { "Member sets tests", [

        {"[]",                           ?_assert( [[]]                         =:= sc:member_sets( [] )                           ) },
        {"[ [] ]",                       ?_assert( [[]]                         =:= sc:member_sets( [ [] ] )                       ) },
        {"[ [1],[2,3] ]",                ?_assert( [[1,2],[1,3]]                =:= sc:member_sets( [ [1],[2,3] ] )                ) },
        {"[ [1],[2,3] ], no_absence",    ?_assert( [[1,2],[1,3]]                =:= sc:member_sets( [ [1],[2,3] ], no_absence )    ) },
        {"[ [1],[2,3] ], allow_absence", ?_assert( [[],[2],[3],[1],[1,2],[1,3]] =:= sc:member_sets( [ [1],[2,3] ], allow_absence ) ) }

    ] }.





count_of_test_() ->

    { "Count of tests", [

        {"3, [1,2,3,4,5]", ?_assert( 1 =:= sc:count_of(3, [1,2,3,4,5]) )},
        {"6, [1,2,3,4,5]", ?_assert( 0 =:= sc:count_of(6, [1,2,3,4,5]) )},
        {"2, [1,2,3,2,1]", ?_assert( 2 =:= sc:count_of(2, [1,2,3,2,1]) )},
        {"b, [1,a,2,b,3]", ?_assert( 1 =:= sc:count_of(b, [1,a,2,b,3]) )}

    ] }.





list_intersection_test_() ->

    { "List intersection tests", [

        {"[3,1,4],[1,5,9]", ?_assert( [1]     =:= sc:list_intersection([3,1,4],[1,5,9]) )},
        {"[3,1,4],[2,5,9]", ?_assert( []      =:= sc:list_intersection([3,1,4],[2,5,9]) )},
        {"[3,1,4],[1,4,3]", ?_assert( [4,3,1] =:= sc:list_intersection([3,1,4],[1,4,3]) )},
        {"[3,1,4],[3,1,4]", ?_assert( [4,3,1] =:= sc:list_intersection([3,1,4],[3,1,4]) )},
        {"[3,a,4],[a,5,3]", ?_assert( [a,3]   =:= sc:list_intersection([3,a,4],[a,5,3]) )}

    ] }.





zip_n_test_() ->

    { "Zip N test", [

        {"[ [1,2,3],[a,b,c] ]",                 ?_assert( [{1,a},  {2,b},  {3,c}]         =:= sc:zip_n([ [1,2,3],[a,b,c] ])                 )},
        {"[ [1,2,3],[a,b,c],[x,y,z] ]",         ?_assert( [{1,a,x},{2,b,y},{3,c,z}]       =:= sc:zip_n([ [1,2,3],[a,b,c],[x,y,z] ])         )},
        {"[ [1,2,3],[a,b,c],[x,y,z],[d,e,f] ]", ?_assert( [{1,a,x,d},{2,b,y,e},{3,c,z,f}] =:= sc:zip_n([ [1,2,3],[a,b,c],[x,y,z],[d,e,f] ]) )},
        {"[ ]",                                 ?_assert( []                              =:= sc:zip_n([ ])                                 )}

    ] }.





combinations_test_() ->

    { "Combinations test", [

        {"0, [a,b,c,d]", ?_assert( []                                    =:= sc:combinations(0, [a,b,c,d]) )},
        {"1, [a,b,c,d]", ?_assert( [[a],[b],[c],[d]]                     =:= sc:combinations(1, [a,b,c,d]) )},
        {"2, [a,b,c,d]", ?_assert( [[a,b],[a,c],[a,d],[b,c],[b,d],[c,d]] =:= sc:combinations(2, [a,b,c,d]) )},
        {"3, [a,b,c,d]", ?_assert( [[a,b,c],[a,b,d],[a,c,d],[b,c,d]]     =:= sc:combinations(3, [a,b,c,d]) )},
        {"4, [a,b,c,d]", ?_assert( [[a,b,c,d]]                           =:= sc:combinations(4, [a,b,c,d]) )},
        {"5, [a,b,c,d]", ?_assert( []                                    =:= sc:combinations(5, [a,b,c,d]) )}

    ] }.





expand_labels_test_() ->

    { "Expand labels test", [

        {"[]",                    ?_assert( []                        =:= sc:expand_labels([])                    )},
        {"[{1,[a,b]}]",           ?_assert( [{1,a},{1,b}]             =:= sc:expand_labels([{1,[a,b]}])           )},
        {"[{1,[a,b]},{2,[c,d]}]", ?_assert( [{1,a},{1,b},{2,c},{2,d}] =:= sc:expand_labels([{1,[a,b]},{2,[c,d]}]) )}

    ] }.





permute_test_() ->

    { "Permute tests", [

        {"[1,2,3]",   ?_assert([[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]] =:= sc:permute([1,2,3])   )},
        {"[1,2,3],2", ?_assert([[1,2],[1,3],[2,1],[2,3],[3,1],[3,2]]             =:= sc:permute([1,2,3],2) )},
        {"[]",        ?_assert([]                                                =:= sc:permute([])        )}

    ] }.





shared_keys_test_() ->

    { "Shared keys tests", [

        {"[],[]",                                   ?_assert([]                =:= sc:shared_keys([],[])                                   )},
        {"[{1,a},{2,a},{3,a}],[{1,b},{3,b},{4,b}]", ?_assert([{1,a,b},{3,a,b}] =:= sc:shared_keys([{1,a},{2,a},{3,a}],[{1,b},{3,b},{4,b}]) )},
        {"[{1,a},{2,a}],[{3,b},{4,b}]",             ?_assert([]                =:= sc:shared_keys([{1,a},{2,a}],[{3,b},{4,b}])             )}

    ] }.





list_product_test_() ->

    { "List product tests", [

        {"[1,2,3]",   ?_assert(6    =:= sc:list_product([1,2,3]))},
        {"[1,2,5.4]", ?_assert(10.8 =:= sc:list_product([1,2,5.4]))},
        {"[1]",       ?_assert(1    =:= sc:list_product([1]))},
        {"[]",        ?_assert(1    =:= sc:list_product([]))}

    ] }.





even_or_odd_test_() ->

    { "Even or odd tests", [

        {"-2", ?_assert(even =:= sc:even_or_odd(-2))},
        {"-1", ?_assert(odd  =:= sc:even_or_odd(-1))},
        {"0",  ?_assert(even =:= sc:even_or_odd(0) )},
        {"1",  ?_assert(odd  =:= sc:even_or_odd(1) )},
        {"2",  ?_assert(even =:= sc:even_or_odd(2) )}

    ] }.

