# Feature Specification: Add NixOS Module

**Feature Branch**: 002-add-nixos-module  
**Created**: 2025-10-22  
**Status**: Draft  
**Input**: User description: ""

## User Scenarios & Testing *(mandatory)*

<!-- User stories should be PRIORITIZED as user journeys ordered by importance. Each user story/journey must be INDEPENDENTLY TESTABLE - meaning if you implement just ONE of them, you should still have a viable MVP (Minimum Viable Product) that delivers value. Assign priorities (P1, P2, P3, etc.) to each story, where P1 is the most critical. -->

### User Story 1 - Enable Declarative Configuration (Priority: P1)

As a NixOS user, I want to configure Arexibo using declarative Nix options so that I can manage my digital signage setup alongside my system configuration.

**Why this priority**: This is the core value of NixOS modules - declarative, reproducible configuration.

**Independent Test**: Can be tested by setting options in configuration.nix and verifying the service starts with those settings.

**Acceptance Scenarios**:

1. **Given** a NixOS configuration with `services.arexibo.enable = true; host = "https://cms.example.com"; key = "mykey"`, **When** I rebuild the system, **Then** the Arexibo service starts with the specified host and key.

---

### User Story 2 - Systemd Integration (Priority: P2)

As a system administrator, I want Arexibo to run as a proper systemd service so that it integrates with system monitoring and logging.

**Why this priority**: Ensures reliable operation and standard system management practices.

**Independent Test**: Can be tested by checking systemctl status and journalctl logs for the service.

**Acceptance Scenarios**:

1. **Given** the module is enabled, **When** the system boots, **Then** the arexibo service is active and managed by systemd.

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST enable declarative configuration of the digital signage service
- **FR-002**: System MUST integrate with NixOS systemd services

### Key Entities *(include if feature involves data)*

- **Arexibo Configuration**: Represents the NixOS module settings with attributes: enable (boolean), host (string), key (string), displayId (optional string), proxy (optional string), dataDir (string), displayName (optional string)

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can enable and configure the Arexibo service using NixOS module options without requiring manual binary installation or systemd service creation

### Non-Functional Quality Attributes

- Performance: Service startup time <10 seconds, memory usage <512 MB

### Integration & External Dependencies

- Relies on Xibo CMS server for content scheduling and authentication
- Uses systemd for service lifecycle management

## Clarifications

### Session 2025-10-22

- Q: What are the primary user goals for adding the NixOS module to Arexibo? → A: Enable declarative configuration of the digital signage service and Integrate with NixOS systemd services
- Q: What measurable success criteria define when the NixOS module is successfully implemented? → A: Users can configure and run Arexibo via NixOS options without manual setup
- Q: What configuration entities should the NixOS module support? → A: enable (bool), host (string), key (string), displayId (optional string), proxy (optional string)
- Q: What performance constraints should the module adhere to? → A: Service startup <10 seconds, memory <512MB
- Q: What external dependencies does the module rely on? → A: Xibo CMS server, systemd

