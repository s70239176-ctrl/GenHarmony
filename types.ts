export interface Track {
  id: string;
  title: string;
  genre: string;
  creator: string;
  status: "active" | "archived";
  current_content: string;
  version: number;
  parent_track_id?: string | null;
}

export interface ProposalScores {
  approve: boolean;
  quality: number;
  originality: number;
  emotional: number;
  canon_fit: number;
  evolved_content: string;
  rationale: string;
}

export interface Proposal {
  id: string;
  track_id: string;
  proposer: string;
  contribution_text: string;
  contribution_type: string;
  status: "pending" | "approved" | "rejected";
  scores: ProposalScores | null;
  evolved_content: string | null;
  rationale: string | null;
}

export interface MintedElement {
  id: string;
  track_id: string;
  kind: string;
  owner: string;
  version_at_mint: number;
}
