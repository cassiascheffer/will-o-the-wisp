-- Sample data for willow_camp development
-- Run this with: psql -h localhost -U postgres -d wc_gleam -f priv/sample_data.sql

-- Clean existing data
TRUNCATE users, blog_configs, posts, pages CASCADE;

-- Insert sample users
INSERT INTO users (id, email, encrypted_password, name, created_at, updated_at, blogs_count) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'willow@acorn.ca', '$2b$12$dummy.hash.for.dev.only', 'Willow', NOW(), NOW(), 1),
('550e8400-e29b-41d4-a716-446655440002', 'winter@acorn.ca', '$2b$12$dummy.hash.for.dev.only', 'Winter', NOW(), NOW(), 1),
('550e8400-e29b-41d4-a716-446655440003', 'merlin@acorn.ca', '$2b$12$dummy.hash.for.dev.only', 'Merlin', NOW(), NOW(), 1);

-- Insert sample blog configs
INSERT INTO blog_configs (id, user_id, subdomain, title, meta_description, theme, created_at, updated_at, primary_blog) VALUES
('650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'willow', 'Willow''s Wagging Tales', 'Adventures of a curious dog', 'light', NOW(), NOW(), true),
('650e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', 'winter', 'Winter''s Walkabouts', 'A dog''s perspective on the world', 'light', NOW(), NOW(), true),
('650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440003', 'merlin', 'Merlin''s Musings', 'The sophisticated thoughts of a distinguished cat', 'light', NOW(), NOW(), true);

-- Insert sample posts for Willow (dog)
INSERT INTO posts (id, title, published, published_at, created_at, updated_at, body_markdown, slug, meta_description, author_id, blog_config_id, featured, has_mermaid_diagrams) VALUES
('750e8400-e29b-41d4-a716-446655440001', 'My Best Friend Winter', true, NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days',
'# My Best Friend Winter

Winter is the BEST! We play together every single day. She''s so much fun!

## Our Daily Routine

```mermaid
graph LR
    A[Wake Up] --> B[Breakfast]
    B --> C[Play with Winter]
    C --> D[Nap Time]
    D --> E[More Play!]
    E --> F[Dinner]
    F --> G[Evening Zoomies]
```

Sometimes Merlin watches us from the window. I think he wishes he could run as fast as us!

Winter and I have the best time chasing each other around the yard. She''s a little bigger than me but I''m faster!',
'my-best-friend-winter', 'All about my best doggo friend Winter', '550e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', true, true),

('750e8400-e29b-41d4-a716-446655440002', 'That Cat Merlin', true, NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days',
'# Understanding Merlin the Cat

Merlin is very mysterious. Here''s what I''ve learned about cat behaviour:

```mermaid
flowchart TD
    A[See Merlin] --> B{Is he interested?}
    B -->|Yes| C[He walks away]
    B -->|No| D[He walks away]
    C --> E[Conclusion: Cats are confusing]
    D --> E
```

Sometimes Merlin lets me sniff him. Those are the best days! He''s actually quite soft, though he pretends not to care.

I think deep down Merlin likes us dogs. He just has a funny way of showing it.',
'that-cat-merlin', 'My observations about our cat friend Merlin', '550e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', false, true);

-- Insert sample posts for Winter (dog)
INSERT INTO posts (id, title, published, published_at, created_at, updated_at, body_markdown, slug, meta_description, author_id, blog_config_id, featured, has_mermaid_diagrams) VALUES
('750e8400-e29b-41d4-a716-446655440003', 'Adventures with Willow', true, NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days',
'# Adventures with Willow

Willow is my adventure buddy! She''s so energetic and curious about everything.

## Our Friendship Journey

```mermaid
timeline
    title Willow & Winter''s Friendship
    First Meeting : Sniffed each other : Wagged tails
    Week 1 : Started playing together : Became best friends
    Month 1 : First synchronized zoomies : Mastered teamwork
    Now : Inseparable companions : Partners in crime
```

Today Willow discovered a particularly interesting stick. It was the best stick either of us had ever seen. We took turns carrying it around the yard for hours.

Merlin observed our stick ceremony from his perch. I think he was impressed.',
'adventures-with-willow', 'Tales of friendship and adventure', '550e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440002', true, true),

('750e8400-e29b-41d4-a716-446655440004', 'Merlin''s Wisdom', true, NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day',
'# Learning from Merlin

Merlin the cat has taught me so much about patience and observation.

## The Art of the Nap (According to Merlin)

```mermaid
pie title "Merlin''s Daily Activities"
    "Napping" : 45
    "Judging us" : 25
    "Eating" : 15
    "Grooming" : 10
    "Reluctantly accepting pets" : 5
```

While Willow and I run around playing, Merlin demonstrates the superior power of doing absolutely nothing. He''s a master of relaxation.

Sometimes I try to nap like Merlin does - in a sunbeam, completely still. But then I remember there are squirrels to chase and I have to go!',
'merlins-wisdom', 'What I''ve learned from our wise cat', '550e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440002', false, true);

-- Insert sample posts for Merlin (cat)
INSERT INTO posts (id, title, published, published_at, created_at, updated_at, body_markdown, slug, meta_description, author_id, blog_config_id, featured, has_mermaid_diagrams) VALUES
('750e8400-e29b-41d4-a716-446655440005', 'On the Subject of Dogs', true, NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days',
'# On the Subject of Dogs

*A Philosophical Treatise by Merlin*

Willow and Winter are... enthusiastic. They possess an energy that I find both fascinating and exhausting to observe.

## The Canine Energy Spectrum

```mermaid
graph TB
    A[Morning Energy Level] -->|Breakfast| B[Maximum Enthusiasm]
    B -->|Play Time| C[Somehow MORE Energy]
    C -->|Still Playing| D[Peak Chaos]
    D -->|Finally| E[Nap]
    E -->|Wake Up| B

    F[Merlin''s Energy] -->|Consistent| G[Dignified Calm]
```

While I maintain a consistent level of sophisticated composure, these dogs cycle through states of excitement that defy logic.

That said, their companionship is... not entirely unwelcome. When Willow sits quietly beside me, I sometimes allow her presence. Winter has a gentle nature that I respect, even if I don''t show it.

## Conclusion

Dogs are loud, messy, and altogether too happy. But they are *my* dogs, and I suppose I shall keep them.',
'on-the-subject-of-dogs', 'A cat''s perspective on canine companions', '550e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440003', true, true),

('750e8400-e29b-41d4-a716-446655440006', 'Winter: A Character Study', true, NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days',
'# Winter: A Character Study

Winter is the larger of the two dogs, yet possesses a surprisingly gentle demeanor.

## Winter''s Personality Traits

```mermaid
mindmap
  root((Winter))
    Gentle
      Patient with Willow
      Careful with toys
      Soft mouth
    Observant
      Watches before acting
      Learns quickly
      Notices everything
    Loyal
      Follows humans everywhere
      Protective
      Trustworthy
    Playful
      Loves fetch
      Enjoys wrestling
      Master of zoomies
```

I have observed Winter carefully over many months. She notices when I''m nearby and adjusts her play accordingly - a consideration that Willow occasionally forgets in her enthusiasm.

Winter also has excellent taste in napping spots. She understands the value of a good sunbeam.',
'winter-character-study', 'An analytical look at Winter the dog', '550e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440003', false, true),

('750e8400-e29b-41d4-a716-446655440007', 'Willow''s Curiosity', true, NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day',
'# Willow''s Curiosity: A Double-Edged Sword

Willow lives up to her namesake - graceful yet unpredictable, bending with the wind of whatever catches her attention.

## A Day in the Life of Willow''s Attention Span

```mermaid
sequenceDiagram
    participant W as Willow
    participant S as Squirrel
    participant T as Toy
    participant Me as Merlin
    participant Wi as Winter

    W->>S: Spot squirrel!
    S->>W: Runs up tree
    W->>T: Find toy instead
    T->>W: This is now the most important thing
    W->>Me: Notice Merlin
    W->>Me: Attempt to engage
    Me->>W: Dismissive tail flick
    W->>Wi: Play with Winter instead!
    Wi->>W: Happy to engage
```

Her curiosity knows no bounds. Just this morning, she discovered me in my favorite reading spot and spent a full three minutes trying to understand why I prefer books to tennis balls.

I find her earnest confusion... endearing. Though I would never admit this to her directly.',
'willows-curiosity', 'Observations on an inquisitive young dog', '550e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440003', false, true);

-- Show what was inserted
SELECT 'Users:' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'Blog Configs:', COUNT(*) FROM blog_configs
UNION ALL
SELECT 'Posts:', COUNT(*) FROM posts;
