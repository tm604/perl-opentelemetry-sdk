use Object::Pad ':experimental(init_expr)';
# ABSTRACT: A basic OpenTelemetry span processor

package OpenTelemetry::SDK::Trace::Span::Processor::Simple;

our $VERSION = '0.017';

class OpenTelemetry::SDK::Trace::Span::Processor::Simple
    :does(OpenTelemetry::Trace::Span::Processor)
{
    use Feature::Compat::Try;
    use Future::AsyncAwait;
    use OpenTelemetry::X;
    use OpenTelemetry;

    field $exporter :param;

    ADJUST {
        die OpenTelemetry::X->create(
            Invalid => "Exporter must implement the OpenTelemetry::Exporter interface: " . ( ref $exporter || $exporter )
        ) unless $exporter && $exporter->DOES('OpenTelemetry::Exporter');
    }

    method on_start ( $span, $context ) { }

    method on_end ($span) {
        try {
            return unless $span->context->trace_flags->sampled;
            $exporter->export( [$span->snapshot] );
        }
        catch ($e) {
            OpenTelemetry->handle_error(
                exception => $e,
                message   => 'unexpected error in ' . ref($self) . '->on_end',
            );
        }

        return;
    }

    async method shutdown ( $timeout = undef ) {
        $exporter->shutdown( $timeout );
    }

    async method force_flush ( $timeout = undef ) {
        $exporter->force_flush( $timeout );
    }
}
