-module(pong_plugin).
-behaviour(gen_event).

-author("gdamjan@gmail.com").

-export([init/1, handle_event/2, terminate/2, handle_call/2, handle_info/2, code_change/3]).


init(_Args) ->
    {ok, []}.

handle_event(Msg, State) ->
    case Msg of
        {in, _Ref, [Server, _, <<"001">>, _Nick, _]} ->
            {ok, Server};
        {in, Ref, [<<>>,<<>>,<<"PING">>, Server]} ->
            Ref:send_data([<<"PONG :">>, Server]),
            {ok, Server};
        {keepalive, Ref} ->
            Ref:send_data(["PING :", State]),
            {ok, State};
        _ ->
            {ok, State}
    end.


handle_call(_Request, State) -> {ok, ok, State}.
handle_info(_Info, State) -> {ok, State}.
code_change(_OldVsn, State, _Extra) -> {ok, State}.
terminate(_Args, _State) -> ok.
