```
Users (Colección)
│
└── {user_id} (Documento)
    ├── name: String
    ├── email: String
    ├── date_created: Timestamp
    │
    ├── medicines (Subcolección)
    │   └── {medicine_id} (Documento)
    │       ├── name: String
    │       ├── dosage: String
    │       ├── description: String
    │       └── date_created: Timestamp
    │
    ├── Routines (Subcolección)
    │   └── {routine_id} (Documento)
    │       ├── medicine_id: String
    │       ├── frequency: String
    │       ├── dosage_time: String
    │       └── estado: String
    │
    └── History (Subcolección)
        └── {history_id} (Documento)
            ├── routine_id: String
            ├── take_status: String
            └── date: Timestamp
```
