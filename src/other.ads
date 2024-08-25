package Other is
    pragma Pure;

    procedure sei;
    procedure cli;

private
    pragma Inline_Always (sei);
    pragma Inline_Always (cli);

    pragma Import (Intrinsic, sei, "__builtin_avr_sei");
    pragma Import (Intrinsic, cli, "__builtin_avr_cli");
end Other;
