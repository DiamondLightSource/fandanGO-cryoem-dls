[![Built with Claude Code](https://img.shields.io/badge/Built%20with-Claude%20Code-6366f1?logo=claude)](https://claude.ai/code)
[![Maintained by DLS](https://img.shields.io/badge/maintained%20by-Diamond%20Light%20Source-blue)](https://github.com/DiamondLightSource)
[![Part of FandanGO](https://img.shields.io/badge/part%20of-FandanGO%20ecosystem-green)](https://github.com/orgs/FragmentScreen/repositories)

# fandanGO-cryoem-dls

**Diamond Light Source FandanGO Plugin for Cryo-EM Metadata Deposition**

---

> **Source of Truth**: This repository (`DiamondLightSource/fandanGO-cryoem-dls`) is the authoritative source maintained by Diamond Light Source. A mirror exists at `FragmentScreen/fandanGO-cryoem-dls` for ecosystem visibility.

---

## Overview

FandanGO plugin for integrating Diamond Light Source cryo-EM metadata from the SmartEM decision system into the ARIA data deposition platform.

This plugin enables the extraction, management, and deposition of cryo-EM experimental metadata from DLS's SmartEM system into ARIA for centralised tracking and sharing within the Fragment Screen / WP4 ecosystem.

### Key Features

- **SmartEM Integration**: Extracts complete hierarchical metadata from DLS's SmartEM API
- **ARIA Deposition**: Submits structured metadata to ARIA with embargo controls
- **Extract -> Transform -> Load**: Clean architecture for metadata pipeline
- **Facility-Specific**: DLS-maintained plugin following FandanGO facility pattern

## Architecture

```
smartem-decisions     fandanGO-cryoem-dls          ARIA
   (DLS server)    ->    (this plugin)    ->    (remote)
     HTTP API              ETL pipeline         HTTP API
```

## Quick Start

```bash
# Clone and install
git clone https://github.com/DiamondLightSource/fandanGO-cryoem-dls.git
cd fandanGO-cryoem-dls
pip install -e .

# Extract metadata from SmartEM
fandango generate-metadata my_project --acquisition-id <uuid>

# Send to ARIA
fandango send-metadata my_project --visit-id <aria_visit_id>
```

## Documentation

Full documentation: <https://DiamondLightSource.github.io/smartem-devtools>

- [Installation](https://diamondlightsource.github.io/smartem-devtools/fandango/installation)
- [Usage](https://diamondlightsource.github.io/smartem-devtools/fandango/usage)
- [Metadata Schema](https://diamondlightsource.github.io/smartem-devtools/fandango/metadata-schema)
- [Troubleshooting](https://diamondlightsource.github.io/smartem-devtools/fandango/troubleshooting)

## Related Repositories

### FandanGO Ecosystem
- [fandanGO-core](https://github.com/FragmentScreen/fandanGO-core) - Plugin framework
- [fandanGO-aria](https://github.com/FragmentScreen/fandanGO-aria) - ARIA API client

### SmartEM
- [smartem-decisions](https://github.com/DiamondLightSource/smartem-decisions) - Source system for metadata

## Contributing

Contributions are welcome. This is an open-source project maintained by Diamond Light Source for the Fragment Screen community.

1. Fork the repository
2. Create a feature branch
3. Make your changes and add tests
4. Submit a Pull Request

Contact: scientificsoftware@diamond.ac.uk

## Acknowledgments

- **FandanGO Framework**: Fragment Screen consortium
- **SmartEM System**: Diamond Light Source Electron Microscopy team
- **ARIA Platform**: Structural biology data repository
- **Fragment Screen**: European structural biology infrastructure project
