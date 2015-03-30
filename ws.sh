#!/usr/bin/env escript
%% -*- erlang -*-
%%! -smp enable -sname ws -mnesia debug verbose

main([String, Path]) ->
    try
        Port = list_to_integer(String),
        serve(Port, Path)
    catch
        A:B ->
            io:format("Error: ~p:~p~n", [A,B]),
            usage()
    end;
main(_) ->
    usage().

usage() ->
    io:format("usage: ws <port:8080> <path:.>~n"),
    halt(1).

serve(Port, Path) ->
    io:format("started listening on ~p serving ~p~n", [Port, Path]),
    inets:start(),

    MimeTypes = [{"html","text/html"},
                 {"htm","text/html"},
                 {"css","text/css"},
                 {"js","application/x-javascript"},
                 {"svg","image/svg+xml"},
                 {"png","image/png"},
                 {"gif","image/gif"},
                 {"jpg","image/jpeg"},
                 {"jpeg","image/jpeg"}
                ],

    {ok, _Pid} = inets:start(httpd,
        [{port, Port},
         {server_name,"ws"},
         {server_root, Path},
         {document_root, Path},
         {bind_address, {127,0,0,1}},
         {directory_index, ["index.html", "index.htm"]},
         {mime_types,MimeTypes}
        ]),

    io:format("supported mimetypes:~n~p~n", [MimeTypes]),

    receive
        _ ->
            ok
    end.
