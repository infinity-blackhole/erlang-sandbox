-module(sandbox_useless).

-export([add/2, hello/0, great_and_add_two/1, hello_via_imported/0, greet/2, old_enough/1,
         right_age/1, oh_god/1, insert/2]).

-import(io, [format/1]).

-compile([debug_info]).

add(X, Y) ->
  X + Y.

hello() ->
  io:format("Hello, plob!~n").

hello_via_imported() ->
  format("Hello, world!~n").

great_and_add_two(X) ->
  hello(),
  add(X, 2).

greet(male, Name) ->
  io:format("Hello Mr. ~s ~n.", [Name]);
greet(femaile, Name) ->
  io:format("Hello Mr. ~s ~n.", [Name]);
greet(_, Name) ->
  io:format("Hello ~s ~n", [Name]).

% Guard
old_enough(X) when X >= 16 ->
  true;
old_enough(_) ->
  false.

% I've compared , and ; in guards to the operators andalso and orelse. They're
% not exactly the same, though. The former pair will catch exceptions as they
% happen while the latter won't. What this means is that if there is an error
% thrown in the first part of the guard X >= N; N >= 0, the second part can still
% be evaluated and the guard might succeed; if an error was thrown in the first
% part of X >= N orelse N >= 0, the second part will also be skipped and the whole
% guard will fail.
right_age(X) when X >= 16, X =< 104 ->
  true;
right_age(_) ->
  false.

% It may be more FAMILIAR, but that doesn't mean 'else' is a good thing. I know
% that writing '; true ->' is a very easy way to get 'else' in Erlang, but we have
% a couple of decades of psychology-of-programming results to show that it's a bad
% idea. I have started to replace:
%
%                           by
%   if X > Y -> a()                if X > Y  -> a()
%     ; true  -> b()                 ; X =< Y -> b()
%   end                             end
%
%   if X > Y -> a()                if X > Y -> a()
%     ; X < Y -> b()                 ; X < Y -> b()
%     ; true  -> c()                 ; X ==Y -> c()
%   end                        end
%
%
% which I find mildly annoying when _writing_ the code but enormously helpful
% when _reading_ it.
oh_god(N) ->
  if N =:= 2 ->
       might_succeed;
     true ->
       always_does  %% this is Erlang's if's 'else!'
  end.

insert(X, []) ->
  [X];
insert(X, Set) ->
  case lists:member(X, Set) of
    true ->
      Set;
    false ->
      [X | Set]
  end.
