from typing import List, Optional
from models.pact import ContactPersona

# Mock personas for development
MOCK_CONTACTS = [
    ContactPersona(
        id="emily_001",
        name="Emily Johnson",
        phone="+1-555-0101",
        email="emily.johnson@example.com",
        avatar_url="https://lh3.googleusercontent.com/aida-public/AB6AXuBogZkAfRShjB3PlGQp9geA3kn47PgQ5x4VMjS-OuRYBmg_mg5ssMqqbai7Uu3yV-2VRV5rjHg142m6s5hzDUQoJhp5H1APK3FuVjqp-etfkgX-BFncQkK7l03UFnnamewOkbV8sRxRChHjpRTWjLLBwaxr9YZu18nFmvAdRCO2VAkrSzFJ-JqPpimPwcxqqdSuKUjzSKRGyS1z3r1HSH6zlqrQm73oG2FKtNcoBbYJFagwyI3rGFni2cFl2RigAzs0omWnIRpexnV4",
        relationship="friend"
    ),
    ContactPersona(
        id="alex_002",
        name="Alex Chen",
        phone="+1-555-0102",
        email="alex.chen@example.com",
        avatar_url="https://lh3.googleusercontent.com/aida-public/AB6AXuBEXfOsBdTcl1Txo23cFmFIwR4AEVWtQ6hCSDAXCoRsh-RWXZseIJh7VoQ8zztMBKXYLrmC4BM70VhMpxfbwocwoF8EK_aY7TOlgbCCBYcdtZXj0Au-fgdEO0Jc7g0bA2dfJ5JXXmyyQRcg7jqE3nRL_KO0-N0CZWYtJMCRDzD8-ast-45_Zb8cFUqY8Rgvs2TuJdDsalbI17ItryoX5_Q6vksWvkdlhMzxADXB_RXYWQjsRBM9Ap3z-g0h7p6aPcREBEup3iOkxXgT",
        relationship="friend"
    ),
    ContactPersona(
        id="sarah_003",
        name="Sarah Williams",
        phone="+1-555-0103",
        email="sarah.williams@example.com",
        avatar_url="https://lh3.googleusercontent.com/aida-public/AB6AXuCidn8LapuaQQEbxdlkSILbbpmWX5YFddPEUVVS0AqWPFvBGwwdiOF6pcHKLHGHd48xdMRIMz385Txukmm62xNIEwkgCRhYTz4-HeHeQjnDiaqkHLU2dYagCNaR8fiLSqePWx78TGouaWeAaD6r7ZHYv0EOdncmlJIguKI-LVjY9GYbKU3Eg8a3pHQRdsTMOrFDgUB9wGnX6TZVluJnexlgydJgW-8eoKOZtGZV8J9-8KpiUNBi2DSk8cqFMzrh2ymbZwllpU7BOxB6",
        relationship="family"
    ),
    ContactPersona(
        id="michael_004",
        name="Michael Brown",
        phone="+1-555-0104",
        email="michael.brown@example.com",
        avatar_url="https://lh3.googleusercontent.com/aida-public/AB6AXuBIsavMcHSxPRblN1n96mGRZozz0b3YbwFoi1FC4OVPuJ_Bhil_QGPe2fyykkALJzkVBmQwe5RSUHnPnxSLCgaXiPi-YGEpvTlOmY1a0513eiKN9i1rCHnZcSnBlNqs46rOcsbgWUGTpFQ0wSFRa9UpVXUe4Ob8zCNRIQIBf2v9ZEmhNC8JgKFoIXD3amoFyRkVsAuIBTao5VCC0tKUPMAj-bfFUUgISqK20OXoG9PRpmzXncSiTBjIu0CXo7Dk-09lG6Hd3Kkyf5Me",
        relationship="colleague"
    ),
    ContactPersona(
        id="dad_005",
        name="Dad",
        phone="+1-555-0105",
        email="dad@example.com",
        avatar_url="https://lh3.googleusercontent.com/aida-public/AB6AXuAGhOCDIBgbkO2X1FrwerkbicaLeOmmuS1okvyRzBlQqPiRA6hAKTZjMtHY91pPlee_DCoWnUDcZrBWMuKQlXIeSml02dRFnEkj0hGAf4yDXpjs9CuH2PXrHPnWwuQFvEa532kdM_x_tsVq5MnahTyDiDCS-9DFjgnjvj7_RymwuZlGt5zMnlPD_IQ_QXWRcXvMtMLVPFAjBs4LbJRfmrYoTgZtR5UQovVlC2nkiPVEMLbXDlXtiG57S8h17bDGOu_UkgF93_zBCBnI",
        relationship="family"
    ),
    ContactPersona(
        id="mom_006",
        name="Mom",
        phone="+1-555-0106",
        email="mom@example.com",
        avatar_url="https://lh3.googleusercontent.com/aida-public/AB6AXuA732CG33VbYhX_gCya0ra2C6xhS3ABt9TirLR2FtNQy319VDHSl_5C_zYzkCMuudHN-RSOR5a1bpB7atTaOVD_kpK6-5Qsl3cYkBF6VU-KxymaQ85uArjeu2nWJxagZv9DqFP145cUCt9dzH5lZ3vhpZxngfASb89OpVvyeV4B9asT7SnlFDD1QWyximfLE4UdgSMbqLU7E4kjIJqTBPYxEePpFEjgjsiJyX2yHp5Lz1C4KwgqPBkVPYV8eJjRdHXrEO31siQ6_LGi",
        relationship="family"
    ),
    ContactPersona(
        id="jessica_007",
        name="Jessica Martinez",
        phone="+1-555-0107",
        email="jessica.martinez@example.com",
        avatar_url="https://lh3.googleusercontent.com/aida-public/AB6AXuCScn4A16ISkL9ZE2trUbxW5BnHuBojJTOBp8-Q7Evyok4dRBaG3V8xmL9t4Ug9W0h3xeKfkfbXySWft8VLqncPvoOoXhM30odhV4xbf8knsQWOriP6koMug7Ko7OODB_gVZ2vMdbwTc5TLXL2622HHR9cNYGsxNYqk2cmkg1QJ9BT4smksc_4bYgdd4g8IqMXI-6ts691UPg0r-99xmZJLJtZxNL4p7QGK_83AIGpiWpPRRQfldSGZgFq1r4NfVPGXK5VqmRf_VT_h",
        relationship="partner"
    ),
    ContactPersona(
        id="david_008",
        name="David Kim",
        phone="+1-555-0108",
        email="david.kim@example.com",
        avatar_url="https://lh3.googleusercontent.com/aida-public/AB6AXuDyW4YuB4366Qwh_uMzqs3ii53OYiU0uVWWjNxREnkKecZAwCJfz9U3iQgp0z8hzXs3BgcYT7ryS_nWqEgzYqlrnQ1LJQRYBkJ2PCHm3zYKbKVgQaHZCbQ5Sdwjimi9Y7mYcsSTTqumrX7mKueSATJZZfGAKZEpgdqM7BPZec64vu_CMmaJH7CIY_EIaQyopKVZ8uFudyMQ0ybw7_ZzVh7gMxFRgbEnBibaMiLzZ_irGPoSOUFEJsmVRZYkXFzGoWDRgycRwkOHZwj8",
        relationship="colleague"
    ),
]

def get_mock_contacts() -> List[ContactPersona]:
    """Get all mock contacts for development"""
    return MOCK_CONTACTS

def get_contact_by_id(contact_id: str) -> Optional[ContactPersona]:
    """Get a specific contact by ID"""
    for contact in MOCK_CONTACTS:
        if contact.id == contact_id:
            return contact
    return None

def search_contacts(query: str) -> List[ContactPersona]:
    """Search contacts by name or phone"""
    query_lower = query.lower()
    return [
        contact for contact in MOCK_CONTACTS
        if query_lower in contact.name.lower() or query_lower in contact.phone
    ]

def get_contacts_by_relationship(relationship: str) -> List[ContactPersona]:
    """Get contacts filtered by relationship type"""
    return [
        contact for contact in MOCK_CONTACTS
        if contact.relationship == relationship
    ]
