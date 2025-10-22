# Data Model: NixOS Module for Arexibo

## Entities

### Arexibo Service Configuration

The primary entity for configuring the Arexibo digital signage service in NixOS.

**Fields:**
- `enable` (Boolean): Flag to enable/disable the Arexibo service. Default: false
- `host` (String): URL of the Xibo CMS server (e.g., "https://cms.example.com"). Required when enabled.
- `key` (String): Display key for authentication with the CMS. Required when enabled.
- `displayId` (Optional String): Unique identifier for this display. Auto-generated if not provided.
- `proxy` (Optional String): Proxy URL for network requests if needed.
- `dataDir` (Optional String): Directory for storing configuration and media cache. Default: "/var/lib/arexibo"
- `displayName` (Optional String): Initial name for this display.

**Relationships:**
- Belongs to NixOS system configuration
- References systemd service for runtime management

## Validation Rules

- `host`: Must be a valid URL starting with "https://"
- `key`: Must be a non-empty string
- `displayId`: If provided, must be a valid identifier (alphanumeric + hyphens)
- `proxy`: If provided, must be a valid URL
- `dataDir`: Must be an absolute path with write permissions

## State Transitions

- **Disabled** → **Enabled**: Validate configuration, create data directory, start systemd service
- **Enabled** → **Disabled**: Stop systemd service, optionally clean data directory
- **Running** → **Error**: Log failure, attempt automatic restart based on systemd configuration
- **Error** → **Running**: Successful reconnection to CMS after transient failure