import { describe, it, expect, beforeEach } from 'vitest';

// Simulated contract state
const tokenBalances = new Map();
let totalSupply = 0;

// Simulated contract functions
function mintTokens(amount: number, recipient: string, minter: string) {
  if (minter !== 'CONTRACT_OWNER') throw new Error('Not authorized');
  const currentBalance = tokenBalances.get(recipient) || 0;
  tokenBalances.set(recipient, currentBalance + amount);
  totalSupply += amount;
  return true;
}

function transferTokens(amount: number, sender: string, recipient: string) {
  const senderBalance = tokenBalances.get(sender) || 0;
  if (senderBalance < amount) throw new Error('Insufficient balance');
  tokenBalances.set(sender, senderBalance - amount);
  const recipientBalance = tokenBalances.get(recipient) || 0;
  tokenBalances.set(recipient, recipientBalance + amount);
  return true;
}

function burnTokens(amount: number, owner: string) {
  const balance = tokenBalances.get(owner) || 0;
  if (balance < amount) throw new Error('Insufficient balance');
  tokenBalances.set(owner, balance - amount);
  totalSupply -= amount;
  return true;
}

describe('Paradox Resolution Token Contract', () => {
  beforeEach(() => {
    tokenBalances.clear();
    totalSupply = 0;
  });
  
  it('should mint new tokens', () => {
    expect(mintTokens(1000, 'scientist1', 'CONTRACT_OWNER')).toBe(true);
    expect(tokenBalances.get('scientist1')).toBe(1000);
    expect(totalSupply).toBe(1000);
  });
  
  it('should transfer tokens between accounts', () => {
    mintTokens(1000, 'scientist1', 'CONTRACT_OWNER');
    expect(transferTokens(500, 'scientist1', 'researcher1')).toBe(true);
    expect(tokenBalances.get('scientist1')).toBe(500);
    expect(tokenBalances.get('researcher1')).toBe(500);
  });
  
  it('should burn tokens', () => {
    mintTokens(1000, 'scientist2', 'CONTRACT_OWNER');
    expect(burnTokens(300, 'scientist2')).toBe(true);
    expect(tokenBalances.get('scientist2')).toBe(700);
    expect(totalSupply).toBe(700);
  });
  
  it('should not allow unauthorized minting', () => {
    expect(() => mintTokens(1000, 'unauthorized_user', 'unauthorized_user')).toThrow('Not authorized');
  });
  
  it('should not allow transfers with insufficient balance', () => {
    mintTokens(500, 'scientist3', 'CONTRACT_OWNER');
    expect(() => transferTokens(1000, 'scientist3', 'researcher2')).toThrow('Insufficient balance');
  });
});

