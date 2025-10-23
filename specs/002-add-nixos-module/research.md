# Research: Digital Signage Player Performance, Constraints, and Scale

## Performance Goals
- **Decision**: Achieve smooth media playback at a minimum of 30 frames per second (FPS) with display update latency under 1 second.
- **Rationale**: This ensures fluid video and animation playback without stuttering or delays, providing a professional user experience in public settings where viewers expect seamless content transitions.
- **Alternatives considered**: Targeting 60 FPS for ultra-smooth playback, or allowing higher latency (up to 5 seconds) for simpler implementations. These were rejected as 30 FPS is industry standard for digital signage, balancing performance with resource efficiency.

## Constraints
- **Decision**: Reasonable resource constraints include 512 MB RAM, 1 CPU core at 1 GHz, and 8 GB storage.
- **Rationale**: These limits align with low-power, embedded hardware commonly used in digital signage deployments, ensuring the application runs efficiently on devices like Raspberry Pi or dedicated media players without excessive power consumption or cost.
- **Alternatives considered**: Higher constraints such as 2 GB RAM or multi-core CPUs for better multitasking, or lower limits (256 MB RAM) for ultra-cheap hardware. Higher specs were deemed unnecessary for typical use cases, while lower limits risk instability during concurrent operations.

## Scale/Scope
- **Decision**: Handle up to 100 displays, media files up to 1080p resolution, and support for up to 5 concurrent operations (e.g., downloading updates while playing content).
- **Rationale**: This scale covers small to medium businesses (e.g., retail chains, offices) with moderate media libraries, allowing efficient content distribution and updates without overwhelming the system.
- **Alternatives considered**: Scaling to thousands of displays or 4K media for enterprise environments, or limiting to single-display setups. Larger scales require distributed architectures, while smaller scopes limit applicability; the chosen range provides a balanced, achievable target for a Rust/Qt implementation like arexibo.