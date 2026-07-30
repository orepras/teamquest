# Starter skill library (PRD §3.3). Idempotent — safe to run repeatedly.
SKILLS = {
  "engineering" => [
    "Ruby / Rails", "JavaScript", "TypeScript", "React", "Vue", "Flutter",
    "Swift / iOS", "Kotlin / Android", "Go", "Python", "PHP / Laravel",
    "SQL & data modeling", "API design", "Testing & QA automation",
    "CI/CD", "Docker & infrastructure", "Cloud (AWS/GCP)", "Security"
  ],
  "design" => [
    "UI design", "UX research", "Figma", "Prototyping", "Design systems",
    "Illustration", "Motion design", "Branding"
  ],
  "product" => [
    "Product discovery", "Roadmapping", "Backlog management", "Scrum / Agile",
    "Estimation & planning", "Stakeholder management", "Analytics & metrics"
  ],
  "operations" => [
    "Recruiting", "Onboarding", "Finance & invoicing", "Vendor management",
    "Office & logistics", "Legal & contracts"
  ],
  "communication" => [
    "Client communication", "Technical writing", "Public speaking",
    "Negotiation", "Mentoring", "Copywriting", "English proficiency"
  ]
}.freeze

SKILLS.each do |category, names|
  names.each do |name|
    Skill.find_or_create_by!(name: name) { |s| s.category = category }
  end
end

puts "Seeded #{Skill.count} skills."
