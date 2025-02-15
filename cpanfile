requires 'Feature::Compat::Try';
requires 'Future', '0.26';             # Future->done
requires 'Future::AsyncAwait', '0.38'; # Object::Pad compatibility
requires 'IO::Async::Loop';
requires 'Metrics::Any';
requires 'Mutex';
requires 'Object::Pad', '0.74'; # For //= field initialisers
requires 'OpenTelemetry';
requires 'String::CRC32';

recommends 'OpenTelemetry::Exporter::OTLP';

on test => sub {
    requires 'File::Temp';
    requires 'JSON::PP';
    requires 'Syntax::Keyword::Dynamically';
    requires 'Test2::V0';
};
